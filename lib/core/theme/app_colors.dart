import 'package:flutter/material.dart';

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color cinzaPrincipal;
  final Color cinzaSecundaria;
  final Color cinzaTerciario;

  final Color sombra;
  final Color bordas;
  final Color sombra2;
  final Color sombra3;

  final Color fundoTela;
  final Color fundoDefault;
  final Color fundoBarraInferior;

  final Color barra;
  final Color botao;

  final Color fonteDestaque;
  final Color fonteDestaque2;
  final Color fonteDefault;

  final Color branco;
  final Color preto;

  final Color icones;

  final Color dificuldadeFacil;
  final Color dificuldadeMedio;
  final Color dificuldadeDificil;
  final Color dificuldadeExtremo;
  final Color dificuldadeKids;

  const AppThemeColors({
    required this.cinzaPrincipal,
    required this.cinzaSecundaria,
    required this.sombra,
    required this.bordas,
    required this.sombra2,
    required this.sombra3,
    required this.fundoTela,
    required this.fundoDefault,
    required this.fundoBarraInferior,
    required this.barra,
    required this.botao,
    required this.fonteDestaque,
    required this.fonteDestaque2,
    required this.fonteDefault,
    required this.branco,
    required this.preto,
    required this.icones,
    required this.dificuldadeFacil,
    required this.dificuldadeMedio,
    required this.dificuldadeDificil,
    required this.dificuldadeExtremo,
    required this.dificuldadeKids,
    required this.cinzaTerciario
  });

  static const light = AppThemeColors(
    cinzaPrincipal: Color(0xFF6D6B6B),
    cinzaSecundaria: Color(0xFF6D6C6C),
    cinzaTerciario: Color(0xFFD9D9D9),
    preto: Color(0xFF000000),

    sombra: Color(0x80000000),
    bordas: Color(0xFFE6DFDF),
    sombra2: Color(0x4DFFFFFF),
    sombra3: Color(0x80FFFFFF),

    fundoTela: Color(0xFFE0E0E0),
    fundoDefault: Color(0xFFE0E0E0),
    fundoBarraInferior: Color(0xFFAEC4B0),

    barra: Color(0xFFFFFFFF),
    botao: Color(0xFF00AC14),

    fonteDestaque: Color(0xFF00AC14),
    fonteDestaque2: Color(0xFFFFFFFF),
    fonteDefault: Color(0xFF000000),

    branco: Color(0xFFFFFFFF),

    icones: Color(0xFF00AC14),

    dificuldadeFacil: Color(0xFF00AC14),
    dificuldadeMedio: Color(0xFFE5BD1E),
    dificuldadeDificil: Color(0xFFFF6767),
    dificuldadeExtremo: Color(0xFFC90000),
    dificuldadeKids: Color(0xFF1DB3D5),
  );

  static const dark = AppThemeColors(
    cinzaPrincipal: Color(0xFFE6E5E5),
    cinzaSecundaria: Color(0xFF6D6C6C),
    cinzaTerciario: Color(0xFF676767),
    preto: Color(0xFF000000),

    sombra: Color(0x80000000),
    bordas: Color(0xFFB5B5B5),
    sombra2: Color(0x4DB4B4B4),
    sombra3: Color(0x80000000),

    fundoTela: Color(0xFF2E3333),
    fundoDefault: Color(0xFF2E3333),
    fundoBarraInferior: Color(0xFF4E5C56),

    barra: Color(0xFFDDDCDC),
    botao: Color(0xFF35604D),

    fonteDestaque: Color(0xFF27F49B),
    fonteDestaque2: Color(0xFF000000),
    fonteDefault: Color(0xFFFFFFFF),

    branco: Color(0xFFFFFFFF),

    icones: Color(0xFF27F49B),
    dificuldadeFacil: Color(0xFF00CD18),
    dificuldadeMedio: Color(0xFFFFD83B),
    dificuldadeDificil: Color(0xFFFF8787),
    dificuldadeExtremo: Color(0xFFFF0000),
    dificuldadeKids: Color(0xFF3ADBFF),
  );

  @override
  AppThemeColors copyWith({
    Color? cinzaPrincipal,
    Color? cinzaSecundaria,
    Color? sombra,
    Color? bordas,
    Color? sombra2,
    Color? sombra3,
    Color? fundoTela,
    Color? fundoDefault,
    Color? fundoBarraInferior,
    Color? barra,
    Color? botao,
    Color? fonteDestaque,
    Color? fonteDestaque2,
    Color? fonteDefault,
    Color? branco,
    Color? icones,
    Color? dificuldadeFacil,
    Color? dificuldadeMedio,
    Color? dificuldadeDificil,
    Color? dificuldadeExtremo,
    Color? dificuldadeKids,
    Color? cinzaTerciario,
    Color? preto,
  }) {
    return AppThemeColors(
      cinzaPrincipal: cinzaPrincipal ?? this.cinzaPrincipal,
      cinzaSecundaria: cinzaSecundaria ?? this.cinzaSecundaria,
      sombra: sombra ?? this.sombra,
      bordas: bordas ?? this.bordas,
      sombra2: sombra2 ?? this.sombra2,
      sombra3: sombra3 ?? this.sombra3,
      fundoTela: fundoTela ?? this.fundoTela,
      fundoDefault: fundoDefault ?? this.fundoDefault,
      fundoBarraInferior: fundoBarraInferior ?? this.fundoBarraInferior,
      barra: barra ?? this.barra,
      botao: botao ?? this.botao,
      fonteDestaque: fonteDestaque ?? this.fonteDestaque,
      fonteDestaque2: fonteDestaque2 ?? this.fonteDestaque2,
      fonteDefault: fonteDefault ?? this.fonteDefault,
      branco: branco?? this.branco,
      icones: icones ?? this.icones,
      dificuldadeFacil: dificuldadeFacil ?? this.dificuldadeFacil,
      dificuldadeMedio: dificuldadeMedio ?? this.dificuldadeMedio,
      dificuldadeDificil: dificuldadeDificil ?? this.dificuldadeDificil,
      dificuldadeExtremo: dificuldadeExtremo ?? this.dificuldadeExtremo,
      dificuldadeKids: dificuldadeKids ?? this.dificuldadeKids,
      cinzaTerciario: cinzaTerciario ?? this.cinzaTerciario,
      preto: preto ?? this.preto,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }

    return AppThemeColors(
      cinzaPrincipal: Color.lerp(cinzaPrincipal, other.cinzaPrincipal, t)!,
      cinzaSecundaria: Color.lerp(cinzaSecundaria, other.cinzaSecundaria, t)!,
      sombra: Color.lerp(sombra, other.sombra, t)!,
      bordas: Color.lerp(bordas, other.bordas, t)!,
      sombra2: Color.lerp(sombra2, other.sombra2, t)!,
      sombra3: Color.lerp(sombra3, other.sombra3, t)!,
      fundoTela: Color.lerp(fundoTela, other.fundoTela, t)!,
      fundoDefault: Color.lerp(fundoDefault, other.fundoDefault, t)!,
      fundoBarraInferior: Color.lerp(fundoBarraInferior, other.fundoBarraInferior, t)!,
      barra: Color.lerp(barra, other.barra, t)!,
      botao: Color.lerp(botao, other.botao, t)!,
      fonteDestaque: Color.lerp(fonteDestaque, other.fonteDestaque, t)!,
      fonteDestaque2: Color.lerp(fonteDestaque2, other.fonteDestaque2, t)!,
      fonteDefault: Color.lerp(fonteDefault, other.fonteDefault, t)!,
      branco: Color.lerp(branco,other.branco, t)!,
      icones: Color.lerp(icones, other.icones, t)!,
      dificuldadeFacil: Color.lerp(dificuldadeFacil, other.dificuldadeFacil, t)!,
      dificuldadeMedio: Color.lerp(dificuldadeMedio, other.dificuldadeMedio, t)!,
      dificuldadeDificil: Color.lerp(dificuldadeDificil, other.dificuldadeDificil, t)!,
      dificuldadeExtremo: Color.lerp(dificuldadeExtremo, other.dificuldadeExtremo, t)!,
      dificuldadeKids: Color.lerp(dificuldadeKids, other.dificuldadeKids, t)!,
      cinzaTerciario: Color.lerp(cinzaTerciario, other.cinzaTerciario, t)!,
      preto: Color.lerp(preto, other.preto, t)!,
    );
  }
}