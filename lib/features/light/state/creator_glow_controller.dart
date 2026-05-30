import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

import '../data/light_storage.dart';
import '../domain/creator_glow_session_state.dart';
import '../domain/light_recipe.dart';

enum CreatorCameraStatus {
  initializing,
  ready,
  companion,
  permissionDenied,
  unavailable,
}

enum CreatorExposureStatus { unknown, tooDim, balanced, tooBright }

class CreatorGlowController extends ChangeNotifier {
  CreatorGlowController({LightStorage? storage})
    : _storage = storage ?? LightStorage();

  static const double minBrightness = 0.3;
  static const double maxBrightness = 1.0;

  static const List<LightRecipe> recipes = <LightRecipe>[
    LightRecipe(
      id: 'natural-glow',
      nameKey: 'naturalGlow',
      scenarioKey: 'naturalGlowScenario',
      color: Color(0xFFFFF4E8),
      recommendedBrightness: 0.88,
      isPro: false,
    ),
    LightRecipe(
      id: 'warm-party',
      nameKey: 'warmParty',
      scenarioKey: 'warmPartyScenario',
      color: Color(0xFFFFE2B8),
      recommendedBrightness: 0.86,
      isPro: false,
    ),
    LightRecipe(
      id: 'soft-pink',
      nameKey: 'softPink',
      scenarioKey: 'softPinkScenario',
      color: Color(0xFFFFD9EC),
      recommendedBrightness: 0.84,
      isPro: false,
    ),
    LightRecipe(
      id: 'makeup-true-tone',
      nameKey: 'makeupTrueTone',
      scenarioKey: 'makeupTrueToneScenario',
      color: Color(0xFFFFF8F0),
      recommendedBrightness: 0.93,
      isPro: false,
    ),
    LightRecipe(
      id: 'mirror-fit',
      nameKey: 'mirrorFit',
      scenarioKey: 'mirrorFitScenario',
      color: Color(0xFFEAF3FF),
      recommendedBrightness: 0.9,
      isPro: false,
    ),
    LightRecipe(
      id: 'low-light-video',
      nameKey: 'lowLightVideo',
      scenarioKey: 'lowLightVideoScenario',
      color: Color(0xFFFFEDD1),
      recommendedBrightness: 0.95,
      isPro: false,
    ),
  ];

  final LightStorage _storage;

  bool _initialized = false;
  bool _isLoading = true;
  int _selectedRecipeIndex = 0;
  double _brightness = recipes.first.recommendedBrightness;
  CreatorCameraStatus _cameraStatus = CreatorCameraStatus.initializing;
  CreatorExposureStatus _exposureStatus = CreatorExposureStatus.unknown;
  CameraController? _cameraController;
  DateTime _lastExposureSampleAt = DateTime.fromMillisecondsSinceEpoch(0);

  bool get initialized => _initialized;
  bool get isLoading => _isLoading;
  int get selectedRecipeIndex => _selectedRecipeIndex;
  double get brightness => _brightness;
  CreatorCameraStatus get cameraStatus => _cameraStatus;
  CreatorExposureStatus get exposureStatus => _exposureStatus;
  CameraController? get cameraController => _cameraController;
  LightRecipe get selectedRecipe => recipes[_selectedRecipeIndex];
  bool get hasCameraPreview =>
      _cameraStatus == CreatorCameraStatus.ready &&
      _cameraController != null &&
      _cameraController!.value.isInitialized;
  bool get isCompanionMode =>
      _cameraStatus == CreatorCameraStatus.companion ||
      _cameraStatus == CreatorCameraStatus.permissionDenied ||
      _cameraStatus == CreatorCameraStatus.unavailable;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _isLoading = true;
    notifyListeners();
    await _restoreSession();
    await _initializeCamera();
    _initialized = true;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _restoreSession() async {
    final CreatorGlowSessionState? session = await _storage
        .loadCreatorSession();
    if (session == null) {
      return;
    }

    final int recipeIndex = recipes.indexWhere(
      (LightRecipe recipe) => recipe.id == session.selectedRecipeId,
    );
    _selectedRecipeIndex = recipeIndex >= 0 ? recipeIndex : 0;
    _brightness = session.brightness.clamp(minBrightness, maxBrightness);
    if (session.useCompanionMode) {
      _cameraStatus = CreatorCameraStatus.companion;
    }
  }

  Future<void> _initializeCamera() async {
    if (_cameraStatus == CreatorCameraStatus.companion) {
      return;
    }

    _cameraStatus = CreatorCameraStatus.initializing;
    _exposureStatus = CreatorExposureStatus.unknown;
    notifyListeners();

    try {
      final List<CameraDescription> cameras = await availableCameras();
      if (cameras.isEmpty) {
        _cameraStatus = CreatorCameraStatus.unavailable;
        await _persist(useCompanionMode: true);
        return;
      }

      final CameraDescription camera = cameras.firstWhere(
        (CameraDescription candidate) =>
            candidate.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final CameraController cameraController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await cameraController.initialize();
      _cameraController = cameraController;
      _cameraStatus = CreatorCameraStatus.ready;
      await _startExposureStream();
    } on CameraException catch (error) {
      _cameraStatus = _isPermissionError(error)
          ? CreatorCameraStatus.permissionDenied
          : CreatorCameraStatus.unavailable;
      await _persist(useCompanionMode: true);
    } catch (_) {
      _cameraStatus = CreatorCameraStatus.unavailable;
      await _persist(useCompanionMode: true);
    }
  }

  bool _isPermissionError(CameraException error) {
    return error.code == 'CameraAccessDenied' ||
        error.code == 'CameraAccessDeniedWithoutPrompt' ||
        error.code == 'CameraAccessRestricted';
  }

  Future<void> _startExposureStream() async {
    final CameraController? controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (controller.value.isStreamingImages) {
      return;
    }

    try {
      await controller.startImageStream(_handleCameraImage);
    } catch (_) {
      _exposureStatus = CreatorExposureStatus.unknown;
    }
  }

  void _handleCameraImage(CameraImage image) {
    final DateTime now = DateTime.now();
    if (now.difference(_lastExposureSampleAt).inMilliseconds < 450) {
      return;
    }
    _lastExposureSampleAt = now;

    final double luma = averageLuma(image);
    final CreatorExposureStatus next = classifyLuma(luma);
    if (next == _exposureStatus) {
      return;
    }
    _exposureStatus = next;
    notifyListeners();
  }

  static double averageLuma(CameraImage image) {
    if (image.planes.isEmpty || image.planes.first.bytes.isEmpty) {
      return 0;
    }
    final List<int> bytes = image.planes.first.bytes;
    final int step = (bytes.length / 1200).ceil().clamp(1, 128);
    int total = 0;
    int count = 0;
    for (int i = 0; i < bytes.length; i += step) {
      total += bytes[i];
      count++;
    }
    if (count == 0) {
      return 0;
    }
    return total / count;
  }

  static CreatorExposureStatus classifyLuma(double luma) {
    if (luma <= 0) {
      return CreatorExposureStatus.unknown;
    }
    if (luma < 70) {
      return CreatorExposureStatus.tooDim;
    }
    if (luma > 190) {
      return CreatorExposureStatus.tooBright;
    }
    return CreatorExposureStatus.balanced;
  }

  Future<void> selectRecipe(int index) async {
    if (index < 0 || index >= recipes.length) {
      return;
    }
    _selectedRecipeIndex = index;
    _brightness = recipes[index].recommendedBrightness.clamp(
      minBrightness,
      maxBrightness,
    );
    await _persist();
    notifyListeners();
  }

  Future<void> setBrightness(double value) async {
    _brightness = value.clamp(minBrightness, maxBrightness);
    await _persist();
    notifyListeners();
  }

  Future<void> adjustBrightnessByDrag(double deltaY) async {
    _brightness = (_brightness - deltaY * 0.0025).clamp(
      minBrightness,
      maxBrightness,
    );
    await _persist();
    notifyListeners();
  }

  Future<void> enableCompanionMode() async {
    await _disposeCamera();
    _cameraStatus = CreatorCameraStatus.companion;
    _exposureStatus = CreatorExposureStatus.unknown;
    await _persist(useCompanionMode: true);
    notifyListeners();
  }

  Future<void> retryCamera() async {
    await _disposeCamera();
    _cameraStatus = CreatorCameraStatus.initializing;
    await _persist(useCompanionMode: false);
    notifyListeners();
    await _initializeCamera();
    notifyListeners();
  }

  Future<void> onAppLifecycleChanged(AppLifecycleState state) async {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      await _disposeCamera();
      return;
    }
    if (state == AppLifecycleState.resumed &&
        _cameraStatus != CreatorCameraStatus.companion) {
      await _initializeCamera();
      notifyListeners();
    }
  }

  Future<void> _persist({bool? useCompanionMode}) async {
    await _storage.saveCreatorSession(
      CreatorGlowSessionState(
        selectedRecipeId: selectedRecipe.id,
        brightness: _brightness,
        useCompanionMode: useCompanionMode ?? isCompanionMode,
      ),
    );
  }

  Future<void> _disposeCamera() async {
    final CameraController? controller = _cameraController;
    _cameraController = null;
    if (controller == null) {
      return;
    }

    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
    } catch (_) {
      // Ignore stream shutdown failures during lifecycle changes.
    }
    await controller.dispose();
  }

  @override
  void dispose() {
    unawaited(_disposeCamera());
    super.dispose();
  }
}
