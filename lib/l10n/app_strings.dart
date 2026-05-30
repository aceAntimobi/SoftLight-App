import 'package:flutter/widgets.dart';

import '../features/light/state/creator_glow_controller.dart';

class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('es'),
    Locale('hi'),
    Locale('ar'),
    Locale('pt'),
    Locale('bn'),
    Locale('ru'),
    Locale('ja'),
    Locale('de'),
  ];

  static const Set<String> _supportedLanguageCodes = <String>{
    'en',
    'zh',
    'es',
    'hi',
    'ar',
    'pt',
    'bn',
    'ru',
    'ja',
    'de',
  };

  static AppStrings of(BuildContext context) {
    return AppStrings(Localizations.localeOf(context));
  }

  String get _lang => _supportedLanguageCodes.contains(locale.languageCode)
      ? locale.languageCode
      : 'en';

  String _text(Map<String, String> values) {
    return values[_lang] ?? values['en']!;
  }

  String get appTitle => _text(<String, String>{
    'en': 'Soft Light',
    'zh': '柔光灯',
    'es': 'Luz Suave',
    'hi': 'सॉफ्ट लाइट',
    'ar': 'إضاءة ناعمة',
    'pt': 'Luz Suave',
    'bn': 'সফট লাইট',
    'ru': 'Мягкий свет',
    'ja': 'ソフトライト',
    'de': 'Weiches Licht',
  });

  String get manualPaletteTitle => _text(<String, String>{
    'en': 'Manual Color Palette',
    'zh': '手动柔光调色盘',
    'es': 'Paleta manual',
    'hi': 'मैनुअल रंग पैलेट',
    'ar': 'لوحة ألوان يدوية',
    'pt': 'Paleta manual de cores',
    'bn': 'ম্যানুয়াল কালার প্যালেট',
    'ru': 'Ручная палитра',
    'ja': '手動カラーパレット',
    'de': 'Manuelle Farbpalette',
  });

  String get manualModeName => _text(<String, String>{
    'en': 'Manual Tone',
    'zh': '手动柔光',
    'es': 'Tono manual',
    'hi': 'मैनुअल टोन',
    'ar': 'لون يدوي',
    'pt': 'Tom manual',
    'bn': 'ম্যানুয়াল টোন',
    'ru': 'Ручной тон',
    'ja': '手動トーン',
    'de': 'Manueller Ton',
  });

  String get cancel => _text(<String, String>{
    'en': 'Cancel',
    'zh': '取消',
    'es': 'Cancelar',
    'hi': 'रद्द करें',
    'ar': 'إلغاء',
    'pt': 'Cancelar',
    'bn': 'বাতিল',
    'ru': 'Отмена',
    'ja': 'キャンセル',
    'de': 'Abbrechen',
  });

  String get apply => _text(<String, String>{
    'en': 'Apply',
    'zh': '应用',
    'es': 'Aplicar',
    'hi': 'लागू करें',
    'ar': 'تطبيق',
    'pt': 'Aplicar',
    'bn': 'প্রয়োগ',
    'ru': 'Применить',
    'ja': '適用',
    'de': 'Anwenden',
  });

  String get save => _text(<String, String>{
    'en': 'Save',
    'zh': '保存',
    'es': 'Guardar',
    'hi': 'सेव करें',
    'ar': 'حفظ',
    'pt': 'Salvar',
    'bn': 'সংরক্ষণ',
    'ru': 'Сохранить',
    'ja': '保存',
    'de': 'Speichern',
  });

  String get saveAsMyMode => _text(<String, String>{
    'en': 'Save as My Mode',
    'zh': '保存为我的模式',
    'es': 'Guardar como mi modo',
    'hi': 'मेरे मोड के रूप में सेव करें',
    'ar': 'حفظ كنمط خاص',
    'pt': 'Salvar como meu modo',
    'bn': 'আমার মোড হিসেবে সংরক্ষণ',
    'ru': 'Сохранить как мой режим',
    'ja': 'マイモードとして保存',
    'de': 'Als meinen Modus speichern',
  });

  String get saveModeTitle => _text(<String, String>{
    'en': 'Save Light Mode',
    'zh': '保存柔光模式',
    'es': 'Guardar modo de luz',
    'hi': 'लाइट मोड सेव करें',
    'ar': 'حفظ نمط الإضاءة',
    'pt': 'Salvar modo de luz',
    'bn': 'লাইট মোড সংরক্ষণ',
    'ru': 'Сохранить режим света',
    'ja': 'ライトモードを保存',
    'de': 'Lichtmodus speichern',
  });

  String get modeNamePlaceholder => _text(<String, String>{
    'en': 'Enter mode name',
    'zh': '输入模式名称',
    'es': 'Ingresa el nombre del modo',
    'hi': 'मोड नाम दर्ज करें',
    'ar': 'أدخل اسم النمط',
    'pt': 'Digite o nome do modo',
    'bn': 'মোডের নাম লিখুন',
    'ru': 'Введите название режима',
    'ja': 'モード名を入力',
    'de': 'Modusname eingeben',
  });

  String get myLightPrefix => _text(<String, String>{
    'en': 'My Light',
    'zh': '我的柔光',
    'es': 'Mi luz',
    'hi': 'मेरी लाइट',
    'ar': 'إضاءتي',
    'pt': 'Minha luz',
    'bn': 'আমার লাইট',
    'ru': 'Мой свет',
    'ja': 'マイライト',
    'de': 'Mein Licht',
  });

  String get timerTitle => _text(<String, String>{
    'en': 'Sleep Timer',
    'zh': '定时关闭',
    'es': 'Temporizador',
    'hi': 'स्लीप टाइमर',
    'ar': 'مؤقت النوم',
    'pt': 'Temporizador',
    'bn': 'স্লিপ টাইমার',
    'ru': 'Таймер сна',
    'ja': 'スリープタイマー',
    'de': 'Sleep-Timer',
  });

  String get cancelTimer => _text(<String, String>{
    'en': 'Cancel Timer',
    'zh': '取消定时',
    'es': 'Cancelar temporizador',
    'hi': 'टाइमर रद्द करें',
    'ar': 'إلغاء المؤقت',
    'pt': 'Cancelar temporizador',
    'bn': 'টাইমার বাতিল করুন',
    'ru': 'Отменить таймер',
    'ja': 'タイマーを停止',
    'de': 'Timer abbrechen',
  });

  String get permanentTimer => _text(<String, String>{
    'en': 'Permanent',
    'zh': '永久',
    'es': 'Permanente',
    'hi': 'स्थायी',
    'ar': 'دائم',
    'pt': 'Permanente',
    'bn': 'স্থায়ী',
    'ru': 'Постоянно',
    'ja': '常時オン',
    'de': 'Permanent',
  });

  String get defaultModesTitle => _text(<String, String>{
    'en': 'Default Modes',
    'zh': '默认模式',
    'es': 'Modos predeterminados',
    'hi': 'डिफ़ॉल्ट मोड',
    'ar': 'الأوضاع الافتراضية',
    'pt': 'Modos padrão',
    'bn': 'ডিফল্ট মোড',
    'ru': 'Стандартные режимы',
    'ja': 'デフォルトモード',
    'de': 'Standardmodi',
  });

  String get myModesTitle => _text(<String, String>{
    'en': 'My Modes',
    'zh': '我的模式',
    'es': 'Mis modos',
    'hi': 'मेरे मोड',
    'ar': 'أوضاعي',
    'pt': 'Meus modos',
    'bn': 'আমার মোড',
    'ru': 'Мои режимы',
    'ja': 'マイモード',
    'de': 'Meine Modi',
  });

  String get addCustomMode => _text(<String, String>{
    'en': 'Add',
    'zh': '新增',
    'es': 'Agregar',
    'hi': 'जोड़ें',
    'ar': 'إضافة',
    'pt': 'Adicionar',
    'bn': 'যোগ করুন',
    'ru': 'Добавить',
    'ja': '追加',
    'de': 'Hinzufügen',
  });

  String get screenBrightnessTitle => _text(<String, String>{
    'en': 'Screen Brightness',
    'zh': '屏幕亮度',
    'es': 'Brillo de pantalla',
    'hi': 'स्क्रीन ब्राइटनेस',
    'ar': 'سطوع الشاشة',
    'pt': 'Brilho da tela',
    'bn': 'স্ক্রিন উজ্জ্বলতা',
    'ru': 'Яркость экрана',
    'ja': '画面の明るさ',
    'de': 'Bildschirmhelligkeit',
  });

  String get webModeTitle =>
      _text(<String, String>{'en': 'Web Mode', 'zh': '网页版'});

  String get webModeValue =>
      _text(<String, String>{'en': 'Page light only', 'zh': '仅调页面光'});

  String get creatorTitle =>
      _text(<String, String>{'en': 'Creator Glow', 'zh': '创作者柔光'});

  String get creatorSubtitle => _text(<String, String>{
    'en': 'Preview soft light for low-light selfies',
    'zh': '低光自拍柔光预览',
  });

  String get creatorCardValue =>
      _text(<String, String>{'en': 'Selfie light', 'zh': '自拍补光'});

  String get companionLightText => _text(<String, String>{
    'en': 'Use this phone as a soft light while another camera records.',
    'zh': '把这台手机当柔光灯，用另一台相机拍摄。',
  });

  String get retryCamera => _text(<String, String>{'en': 'Retry', 'zh': '重试'});

  String get lightOnly =>
      _text(<String, String>{'en': 'Light only', 'zh': '只用灯光'});

  String recipeName(String key) {
    switch (key) {
      case 'naturalGlow':
        return _text(<String, String>{'en': 'Natural Glow', 'zh': '自然柔光'});
      case 'warmParty':
        return _text(<String, String>{'en': 'Warm Party', 'zh': '暖调聚会'});
      case 'softPink':
        return _text(<String, String>{'en': 'Soft Pink', 'zh': '柔粉自拍'});
      case 'makeupTrueTone':
        return _text(<String, String>{'en': 'Makeup True Tone', 'zh': '妆容真色'});
      case 'mirrorFit':
        return _text(<String, String>{'en': 'Mirror Fit', 'zh': '镜前穿搭'});
      case 'lowLightVideo':
        return _text(<String, String>{'en': 'Low-Light Video', 'zh': '低光视频'});
      default:
        return key;
    }
  }

  String recipeScenario(String key) {
    switch (key) {
      case 'naturalGlowScenario':
        return _text(<String, String>{
          'en': 'Clean everyday face light',
          'zh': '日常自然提亮',
        });
      case 'warmPartyScenario':
        return _text(<String, String>{
          'en': 'Warm night-out tone',
          'zh': '夜晚暖调氛围',
        });
      case 'softPinkScenario':
        return _text(<String, String>{
          'en': 'Soft rosy close-ups',
          'zh': '柔粉近景自拍',
        });
      case 'makeupTrueToneScenario':
        return _text(<String, String>{
          'en': 'Neutral makeup check',
          'zh': '妆容颜色校准',
        });
      case 'mirrorFitScenario':
        return _text(<String, String>{
          'en': 'Cool mirror shots',
          'zh': '清爽镜前记录',
        });
      case 'lowLightVideoScenario':
        return _text(<String, String>{
          'en': 'Brighter short videos',
          'zh': '低光短视频提亮',
        });
      default:
        return key;
    }
  }

  String exposureStatus(CreatorExposureStatus status) {
    switch (status) {
      case CreatorExposureStatus.tooDim:
        return _text(<String, String>{'en': 'Too dim', 'zh': '偏暗'});
      case CreatorExposureStatus.balanced:
        return _text(<String, String>{'en': 'Balanced', 'zh': '亮度适中'});
      case CreatorExposureStatus.tooBright:
        return _text(<String, String>{'en': 'Too bright', 'zh': '偏亮'});
      case CreatorExposureStatus.unknown:
        return _text(<String, String>{'en': 'Preview light', 'zh': '预览补光'});
    }
  }

  String creatorCameraStatus(CreatorCameraStatus status) {
    switch (status) {
      case CreatorCameraStatus.initializing:
        return _text(<String, String>{'en': 'Starting camera', 'zh': '正在启动相机'});
      case CreatorCameraStatus.ready:
        return _text(<String, String>{'en': 'Camera preview', 'zh': '相机预览'});
      case CreatorCameraStatus.companion:
        return _text(<String, String>{'en': 'Companion Light', 'zh': '外置柔光灯'});
      case CreatorCameraStatus.permissionDenied:
        return _text(<String, String>{
          'en': 'Camera access needed',
          'zh': '需要相机权限',
        });
      case CreatorCameraStatus.unavailable:
        return _text(<String, String>{
          'en': 'Camera unavailable',
          'zh': '相机不可用',
        });
    }
  }

  String timerMinutes(int minutes) => _text(<String, String>{
    'en': '$minutes min',
    'zh': '$minutes 分钟',
    'es': '$minutes min',
    'hi': '$minutes मिनट',
    'ar': '$minutes دقيقة',
    'pt': '$minutes min',
    'bn': '$minutes মিনিট',
    'ru': '$minutes мин',
    'ja': '$minutes 分',
    'de': '$minutes Min',
  });

  String timerEndsIn(String value) => _text(<String, String>{
    'en': 'Ends in $value',
    'zh': '剩余 $value',
    'es': 'Termina en $value',
    'hi': '$value में समाप्त',
    'ar': 'ينتهي خلال $value',
    'pt': 'Termina em $value',
    'bn': '$value পরে শেষ',
    'ru': 'Закончится через $value',
    'ja': '$value で終了',
    'de': 'Endet in $value',
  });

  String timerEndsInShort(String value) => _text(<String, String>{
    'en': 'Timer $value',
    'zh': '定时 $value',
    'es': 'Timer $value',
    'hi': 'टाइमर $value',
    'ar': 'المؤقت $value',
    'pt': 'Timer $value',
    'bn': 'টাইমার $value',
    'ru': 'Таймер $value',
    'ja': 'タイマー $value',
    'de': 'Timer $value',
  });

  String brightnessPercent(int percent) => _text(<String, String>{
    'en': 'Brightness $percent%',
    'zh': '亮度 $percent%',
    'es': 'Brillo $percent%',
    'hi': 'चमक $percent%',
    'ar': 'السطوع $percent%',
    'pt': 'Brilho $percent%',
    'bn': 'উজ্জ্বলতা $percent%',
    'ru': 'Яркость $percent%',
    'ja': '明るさ $percent%',
    'de': 'Helligkeit $percent%',
  });

  String lightBrightnessPercent(int percent) => _text(<String, String>{
    'en': 'Light $percent%',
    'zh': '灯光 $percent%',
    'es': 'Luz $percent%',
    'hi': 'लाइट $percent%',
    'ar': 'الإضاءة $percent%',
    'pt': 'Luz $percent%',
    'bn': 'লাইট $percent%',
    'ru': 'Свет $percent%',
    'ja': 'ライト $percent%',
    'de': 'Licht $percent%',
  });

  String screenBrightnessPercent(int percent) => _text(<String, String>{
    'en': '$percent%',
    'zh': '$percent%',
    'es': '$percent%',
    'hi': '$percent%',
    'ar': '$percent%',
    'pt': '$percent%',
    'bn': '$percent%',
    'ru': '$percent%',
    'ja': '$percent%',
    'de': '$percent%',
  });

  String get gestureHint => _text(<String, String>{
    'en': 'Swipe left/right to switch · up/down for brightness',
    'zh': '左右切换模式 · 上下调亮度',
    'es': 'Desliza izq/der para cambiar · arriba/abajo para brillo',
    'hi': 'बाएँ/दाएँ स्वाइप करें · ऊपर/नीचे से चमक बदलें',
    'ar': 'اسحب يمينًا/يسارًا للتبديل · أعلى/أسفل للسطوع',
    'pt': 'Deslize esq/dir · cima/baixo para brilho',
    'bn': 'বাম/ডানে সোয়াইপ · উপর/নিচে উজ্জ্বলতা',
    'ru': 'Свайп влево/вправо · вверх/вниз для яркости',
    'ja': '左右で切替 · 上下で明るさ調整',
    'de': 'Links/rechts wechseln · hoch/runter für Helligkeit',
  });

  List<String> get defaultModeNames {
    switch (_lang) {
      case 'zh':
        return const <String>[
          '纯白光',
          '浅白光',
          '米白光',
          '暖白光',
          '暖黄光',
          '冷白光',
          '柔粉光',
          '奶油杏',
          '玫瑰粉',
          '专注琥珀',
          '海盐青',
          '薰衣紫',
        ];
      case 'es':
        return const <String>[
          'Blanco Puro',
          'Blanco Suave',
          'Blanco Marfil',
          'Blanco Cálido',
          'Amarillo Cálido',
          'Blanco Frío',
          'Rosa Suave',
          'Albaricoque',
          'Rosa Rosé',
          'Ámbar Focus',
          'Cian Marino',
          'Lavanda',
        ];
      case 'hi':
        return const <String>[
          'शुद्ध सफेद',
          'हल्का सफेद',
          'आइवरी सफेद',
          'गर्म सफेद',
          'गर्म पीला',
          'ठंडा सफेद',
          'मुलायम गुलाबी',
          'क्रीम खूबानी',
          'रोज़ पिंक',
          'फोकस एम्बर',
          'समुद्री सायन',
          'लैवेंडर',
        ];
      case 'ar':
        return const <String>[
          'أبيض نقي',
          'أبيض ناعم',
          'أبيض عاجي',
          'أبيض دافئ',
          'أصفر دافئ',
          'أبيض بارد',
          'وردي ناعم',
          'مشمشي كريمي',
          'وردي روز',
          'عنبري تركيز',
          'سماوي بحري',
          'لافندر',
        ];
      case 'pt':
        return const <String>[
          'Branco Puro',
          'Branco Suave',
          'Branco Marfim',
          'Branco Quente',
          'Amarelo Quente',
          'Branco Frio',
          'Rosa Suave',
          'Damasco Creme',
          'Rosa Rosé',
          'Âmbar Foco',
          'Ciano Marinho',
          'Lavanda',
        ];
      case 'bn':
        return const <String>[
          'বিশুদ্ধ সাদা',
          'হালকা সাদা',
          'আইভরি সাদা',
          'উষ্ণ সাদা',
          'উষ্ণ হলুদ',
          'শীতল সাদা',
          'নরম গোলাপি',
          'ক্রিম এপ্রিকট',
          'রোজ পিংক',
          'ফোকাস অ্যাম্বার',
          'সামুদ্রিক সায়ান',
          'ল্যাভেন্ডার',
        ];
      case 'ru':
        return const <String>[
          'Чистый белый',
          'Мягкий белый',
          'Айвори белый',
          'Теплый белый',
          'Теплый желтый',
          'Холодный белый',
          'Нежный розовый',
          'Крем-абрикос',
          'Розовый румянец',
          'Фокус янтарь',
          'Морской циан',
          'Лаванда',
        ];
      case 'ja':
        return const <String>[
          'ピュアホワイト',
          'ソフトホワイト',
          'アイボリーホワイト',
          'ウォームホワイト',
          '暖かい黄',
          'クールホワイト',
          'ソフトピンク',
          'クリーム杏',
          'ローズピンク',
          '集中アンバー',
          'シーシアン',
          'ラベンダー',
        ];
      case 'de':
        return const <String>[
          'Reinweiß',
          'Zartweiß',
          'Elfenbeinweiß',
          'Warmweiß',
          'Warmgelb',
          'Kaltweiß',
          'Sanftes Rosa',
          'Creme-Aprikose',
          'Rosé Pink',
          'Fokus-Amber',
          'Meer-Cyan',
          'Lavendel',
        ];
      default:
        return const <String>[
          'Pure White',
          'Soft White',
          'Ivory White',
          'Warm White',
          'Warm Yellow',
          'Cool White',
          'Soft Pink',
          'Cream Apricot',
          'Rose Pink',
          'Focus Amber',
          'Sea Cyan',
          'Lavender',
        ];
    }
  }
}
