import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'state/app_model.dart';

@immutable
class AppPalette {
  const AppPalette({
    required this.primary,
    required this.secondary,
    required this.dark,
    required this.primaryLight,
    required this.accent,
    required this.background,
    required this.card,
    required this.textPrimary,
    required this.textSecondary,
    required this.textLight,
    required this.border,
    required this.danger,
    required this.warning,
    required this.info,
    required this.surface,
    required this.tabBar,
    required this.tabIconDefault,
    required this.tabIconSelected,
    required this.shadow,
    required this.inputBg,
    required this.headerBg,
  });

  final Color primary;
  final Color secondary;
  final Color dark;
  final Color primaryLight;
  final Color accent;
  final Color background;
  final Color card;
  final Color textPrimary;
  final Color textSecondary;
  final Color textLight;
  final Color border;
  final Color danger;
  final Color warning;
  final Color info;
  final Color surface;
  final Color tabBar;
  final Color tabIconDefault;
  final Color tabIconSelected;
  final Color shadow;
  final Color inputBg;
  final Color headerBg;
}

const AppPalette lightPalette = AppPalette(
  primary: Color(0xFF0A84FF),
  secondary: Color(0xFF5AC8FA),
  dark: Color(0xFF0E1726),
  primaryLight: Color(0xFFE8F1FF),
  accent: Color(0xFF34C759),
  background: Color(0xFFF3F6FB),
  card: Color(0xF2FFFFFF),
  textPrimary: Color(0xFF111827),
  textSecondary: Color(0xFF5B6472),
  textLight: Color(0xFF98A2B3),
  border: Color(0xFFE4EAF3),
  danger: Color(0xFFFF453A),
  warning: Color(0xFFFF9F0A),
  info: Color(0xFF64D2FF),
  surface: Color(0xFFEFF4FA),
  tabBar: Color(0xEFFFFFFF),
  tabIconDefault: Color(0xFF7C879A),
  tabIconSelected: Color(0xFF0A84FF),
  shadow: Color(0x12091A2B),
  inputBg: Color(0xF7FFFFFF),
  headerBg: Color(0x00000000),
);

const AppPalette darkPalette = AppPalette(
  primary: Color(0xFF4DA3FF),
  secondary: Color(0xFF64D2FF),
  dark: Color(0xFF07101D),
  primaryLight: Color(0xFF162235),
  accent: Color(0xFF30D158),
  background: Color(0xFF0B1220),
  card: Color(0xD8162030),
  textPrimary: Color(0xFFF8FAFC),
  textSecondary: Color(0xFFC1CBD9),
  textLight: Color(0xFF7D8AA0),
  border: Color(0xFF243247),
  danger: Color(0xFFFF6961),
  warning: Color(0xFFFFB340),
  info: Color(0xFF70D7FF),
  surface: Color(0xFF121B2A),
  tabBar: Color(0xD8131B27),
  tabIconDefault: Color(0xFF7D8AA0),
  tabIconSelected: Color(0xFF7CBAFF),
  shadow: Color(0x4D000000),
  inputBg: Color(0xD81A2434),
  headerBg: Color(0x00000000),
);

AppPalette paletteOf(BuildContext context) {
  final bool isDark = context.select<AppModel, bool>(
    (AppModel model) => model.isDark,
  );
  return isDark ? darkPalette : lightPalette;
}

bool isDarkTheme(BuildContext context) {
  return context.select<AppModel, bool>((AppModel model) => model.isDark);
}

ThemeData buildTheme(AppPalette palette, bool isDark) {
  final ThemeData base = isDark
      ? ThemeData.dark(useMaterial3: true)
      : ThemeData.light(useMaterial3: true);
  final TextTheme bodyText = GoogleFonts.manropeTextTheme(base.textTheme);
  final TextTheme textTheme = bodyText.copyWith(
    displayLarge: GoogleFonts.manrope(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      color: palette.textPrimary,
      letterSpacing: -1.8,
    ),
    displayMedium: GoogleFonts.manrope(
      fontSize: 38,
      fontWeight: FontWeight.w800,
      color: palette.textPrimary,
      letterSpacing: -1.3,
    ),
    headlineMedium: GoogleFonts.manrope(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      color: palette.textPrimary,
      letterSpacing: -0.9,
    ),
    titleLarge: GoogleFonts.manrope(
      fontSize: 22,
      fontWeight: FontWeight.w800,
      color: palette.textPrimary,
      letterSpacing: -0.5,
    ),
    titleMedium: GoogleFonts.manrope(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: palette.textPrimary,
    ),
    bodyLarge: GoogleFonts.manrope(
      fontSize: 16,
      height: 1.55,
      fontWeight: FontWeight.w600,
      color: palette.textPrimary,
    ),
    bodyMedium: GoogleFonts.manrope(
      fontSize: 14,
      height: 1.55,
      fontWeight: FontWeight.w600,
      color: palette.textPrimary,
    ),
    bodySmall: GoogleFonts.manrope(
      fontSize: 12,
      height: 1.45,
      fontWeight: FontWeight.w600,
      color: palette.textSecondary,
    ),
    labelLarge: GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.1,
      color: palette.textPrimary,
    ),
  );
  final ColorScheme scheme =
      ColorScheme.fromSeed(
        seedColor: palette.primary,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ).copyWith(
        primary: palette.primary,
        secondary: palette.secondary,
        error: palette.danger,
        surface: palette.card,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onError: Colors.white,
        onSurface: palette.textPrimary,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: palette.background,
    cardColor: palette.card,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: palette.headerBg,
      surfaceTintColor: Colors.transparent,
      foregroundColor: palette.textPrimary,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      titleTextStyle: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: palette.textPrimary,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.inputBg,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: palette.textLight,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: palette.border, width: 1.1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: palette.primary, width: 1.5),
      ),
      prefixIconColor: palette.textSecondary,
      suffixIconColor: palette.textSecondary,
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 70,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      indicatorColor: palette.primary.withValues(alpha: isDark ? 0.18 : 0.12),
      labelTextStyle: WidgetStatePropertyAll<TextStyle>(
        GoogleFonts.manrope(fontSize: 11.5, fontWeight: FontWeight.w800),
      ),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
        Set<WidgetState> states,
      ) {
        final bool selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? palette.tabIconSelected : palette.tabIconDefault,
          size: selected ? 22 : 21,
        );
      }),
    ),
    dividerColor: palette.border,
    dialogTheme: DialogThemeData(
      backgroundColor: palette.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: palette.dark,
      contentTextStyle: GoogleFonts.manrope(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  );
}

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    palette.background,
                    palette.background.withValues(alpha: 0.98),
                    palette.surface.withValues(alpha: 0.65),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -110,
                    right: -30,
                    child: _GlowOrb(
                      size: 260,
                      color: palette.primary.withValues(alpha: 0.14),
                    ),
                  ),
                  Positioned(
                    top: 120,
                    left: -70,
                    child: _GlowOrb(
                      size: 210,
                      color: palette.secondary.withValues(alpha: 0.12),
                    ),
                  ),
                  Positioned(
                    bottom: -80,
                    right: 20,
                    child: _GlowOrb(
                      size: 220,
                      color: palette.accent.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[color, color.withValues(alpha: 0)],
        ),
      ),
    );
  }
}

class FitnessCard extends StatelessWidget {
  const FitnessCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.only(bottom: 12),
    this.onTap,
    this.color,
    this.borderColor,
    this.gradient,
    this.radius = 26,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final Gradient? gradient;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final BorderRadius radiusValue = BorderRadius.circular(radius);
    final Widget content = Padding(
      padding: margin,
      child: ClipRRect(
        borderRadius: radiusValue,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: gradient == null
                  ? (color ?? palette.card).withValues(
                      alpha: gradient == null ? 0.94 : 1,
                    )
                  : null,
              gradient: gradient,
              borderRadius: radiusValue,
              border: Border.all(
                color:
                    borderColor ??
                    palette.border.withValues(
                      alpha: isDarkTheme(context) ? 0.38 : 0.9,
                    ),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: palette.shadow,
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: Colors.white.withValues(
                    alpha: isDarkTheme(context) ? 0.02 : 0.45,
                  ),
                  blurRadius: 0,
                  offset: const Offset(0, 1),
                  spreadRadius: -0.5,
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: radiusValue, onTap: onTap, child: content),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outline = false,
    this.small = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outline;
  final bool small;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final Color background = outline
        ? palette.card.withValues(alpha: isDarkTheme(context) ? 0.72 : 0.85)
        : palette.primary;
    final Color foreground = outline ? palette.textPrimary : Colors.white;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: outline ? 0 : 4,
          shadowColor: palette.primary.withValues(alpha: 0.22),
          surfaceTintColor: Colors.transparent,
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: background.withValues(alpha: 0.6),
          disabledForegroundColor: foreground.withValues(alpha: 0.6),
          padding: EdgeInsets.symmetric(
            horizontal: small ? 16 : 20,
            vertical: small ? 12 : 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(small ? 16 : 18),
            side: outline
                ? BorderSide(
                    color: palette.border.withValues(alpha: 0.9),
                    width: 1.1,
                  )
                : BorderSide.none,
          ),
        ),
        onPressed: loading ? null : onPressed,
        child: loading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foreground),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (icon != null) ...<Widget>[
                    Icon(icon, size: small ? 16 : 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: small ? 14 : 15,
                      letterSpacing: 0.1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ChipButton extends StatelessWidget {
  const ChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        labelStyle: TextStyle(
          color: selected ? palette.primary : palette.textSecondary,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: palette.card.withValues(alpha: 0.72),
        selectedColor: palette.primary.withValues(alpha: 0.12),
        side: BorderSide(
          color: selected
              ? palette.primary.withValues(alpha: 0.22)
              : palette.border.withValues(alpha: 0.9),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: palette.card.withValues(alpha: 0.72),
                foregroundColor: palette.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                  side: BorderSide(
                    color: palette.border.withValues(alpha: 0.9),
                  ),
                ),
              ),
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: TextStyle(
                  color: palette.primary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.value,
    required this.size,
    required this.strokeWidth,
    required this.child,
    this.color,
  });

  final double value;
  final double size;
  final double strokeWidth;
  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value.clamp(0, 1),
              strokeWidth: strokeWidth,
              backgroundColor: palette.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? palette.primary,
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.suffix,
    this.prefix,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final Widget? suffix;
  final Widget? prefix;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            color: palette.textSecondary,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffix,
            prefixIcon: prefix,
          ),
        ),
      ],
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.background,
    this.foreground,
    this.icon,
  });

  final String label;
  final Color? background;
  final Color? foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final Color bg = background ?? palette.surface;
    final Color fg = foreground ?? palette.textSecondary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: fg.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, color: fg, size: 14),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class ExerciseIllustration extends StatelessWidget {
  const ExerciseIllustration({
    super.key,
    required this.name,
    this.color,
    this.size = 72,
  });

  final String name;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final IconData icon = _iconForExercise(name);
    final Color resolved = color ?? palette.primary;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: resolved.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size / 3),
      ),
      child: Icon(icon, color: resolved, size: size * 0.42),
    );
  }

  IconData _iconForExercise(String exercise) {
    final String lower = exercise.toLowerCase();
    if (lower.contains('run') || lower.contains('sprint')) {
      return Icons.directions_run;
    }
    if (lower.contains('jump') || lower.contains('burpee')) {
      return Icons.air;
    }
    if (lower.contains('plank') || lower.contains('core')) {
      return Icons.self_improvement;
    }
    if (lower.contains('stretch') ||
        lower.contains('pose') ||
        lower.contains('dog')) {
      return Icons.accessibility_new;
    }
    if (lower.contains('row') || lower.contains('pull')) {
      return Icons.fitness_center;
    }
    if (lower.contains('press') || lower.contains('push')) {
      return Icons.sports_gymnastics;
    }
    if (lower.contains('squat') ||
        lower.contains('lunge') ||
        lower.contains('deadlift')) {
      return Icons.accessibility;
    }
    return Icons.fitness_center;
  }
}

void showAppSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
