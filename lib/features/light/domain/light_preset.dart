import 'package:flutter/cupertino.dart';

class LightPreset {
  const LightPreset({
    required this.id,
    required this.name,
    required this.color,
    required this.recommendedBrightness,
    required this.isBuiltIn,
    this.createdAt,
  });

  final String id;
  final String name;
  final Color color;
  final double recommendedBrightness;
  final bool isBuiltIn;
  final int? createdAt;

  factory LightPreset.fromMap(Map<String, dynamic> map) {
    return LightPreset(
      id:
          map['id'] as String? ??
          'custom-${DateTime.now().millisecondsSinceEpoch}',
      name: map['name'] as String? ?? 'My Light',
      color: Color(map['color'] as int? ?? CupertinoColors.white.toARGB32()),
      recommendedBrightness:
          (map['recommendedBrightness'] as num?)?.toDouble() ?? 0.82,
      isBuiltIn: map['isBuiltIn'] as bool? ?? false,
      createdAt: map['createdAt'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'color': color.toARGB32(),
      'recommendedBrightness': recommendedBrightness,
      'isBuiltIn': isBuiltIn,
      'createdAt': createdAt,
    };
  }

  LightPreset copyWith({
    String? id,
    String? name,
    Color? color,
    double? recommendedBrightness,
    bool? isBuiltIn,
    int? createdAt,
  }) {
    return LightPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      recommendedBrightness:
          recommendedBrightness ?? this.recommendedBrightness,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
