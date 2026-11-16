import 'package:flutter/material.dart';

import 'app_controller.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_shell.dart';
import 'screens/welcome_screen.dart';
import 'texts.dart';

/// Gives every screen the [AppController] and rebuilds them when it changes.
class AppScope extends InheritedNotifier<AppController> {
  const AppScope({
    super.key,
    required AppController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// The app's words in the current language. Screens that call this are
  /// rebuilt when the phone's language changes.
  static AppTexts textsOf(BuildContext context) {
    Localizations.localeOf(context);
    return of(context).texts;
  }
}

/// The colours that give the app its look: rice paper, lacquer red, old gold
/// and ink. Read with `Tones.of(context)`.
class Tones extends ThemeExtension<Tones> {
  const Tones({
    required this.paper,
    required this.card,
    required this.lacquer,
    required this.onLacquer,
    required this.gold,
    required this.ink,
    required this.muted,
    required this.line,
  });

  static const light = Tones(
    paper: Color(0xFFF5EDDC),
    card: Color(0xFFFFFBF3),
    lacquer: Color(0xFF9B2C22),
    onLacquer: Color(0xFFFFF4E0),
    gold: Color(0xFFB0802F),
    ink: Color(0xFF2B1F19),
    muted: Color(0xFF76675A),
    line: Color(0xFFE3D6BD),
  );

  static const dark = Tones(
    paper: Color(0xFF1A1411),
    card: Color(0xFF261E19),
    lacquer: Color(0xFF8E2A20),
    onLacquer: Color(0xFFFFEFD6),
    gold: Color(0xFFD9B56A),
    ink: Color(0xFFF2E8D9),
    muted: Color(0xFFB5A594),
    line: Color(0xFF3D322A),
  );

  static Tones of(BuildContext context) =>
      Theme.of(context).extension<Tones>()!;

  /// The background of the screens.
  final Color paper;
  final Color card;

  /// The deep red of lacquerware and seals.
  final Color lacquer;
  final Color onLacquer;
  final Color gold;

  /// Main text.
  final Color ink;

  /// Secondary text.
  final Color muted;

  /// Hairlines and borders.
  final Color line;

  @override
  Tones copyWith() => this;

  @override
  Tones lerp(Tones? other, double t) => t < 0.5 ? this : other ?? this;
}

/// The typeface of titles. It has Latin and Vietnamese letters; Chinese,
/// Japanese and Korean titles fall back to the phone's own font.
const serif = 'NotoSerif';

class AncestryDayApp extends StatelessWidget {
  const AncestryDayApp({super.key, required this.controller, this.locale});

  final AppController controller;

  /// Forces a language (used by tests); normally the phone's is followed.
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      controller: controller,
      // Rebuilt when the controller changes, so picking a language or a
      // calendar in the app takes effect at once.
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) => _app(),
      ),
    );
  }

  Widget _app() {
    final choice = controller.languageChoice;
    return MaterialApp(
      onGenerateTitle: (context) => AppScope.textsOf(context).appName,
      debugShowCheckedModeBanner: false,
      // A language picked in the app wins; otherwise the phone's is used.
      locale: locale ?? (choice == null ? null : localeOfKey(choice)),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeListResolutionCallback: (device, supported) =>
          resolveLocale(device),
      builder: (context, child) {
        // Keeps notifications in the language shown.
        controller.setLocale(Localizations.localeOf(context));
        return child!;
      },
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      home: controller.hasChosenRegion
          ? const HomeShell()
          : const WelcomeScreen(),
    );
  }

  ThemeData _theme(Brightness brightness) {
    final tones = brightness == Brightness.light ? Tones.light : Tones.dark;
    final accent = brightness == Brightness.light
        ? tones.lacquer
        : const Color(0xFFE79A80);
    final scheme =
        ColorScheme.fromSeed(
          seedColor: Tones.light.lacquer,
          brightness: brightness,
        ).copyWith(
          primary: accent,
          onPrimary: brightness == Brightness.light
              ? tones.onLacquer
              : const Color(0xFF3A0D08),
          surface: tones.paper,
          onSurface: tones.ink,
          onSurfaceVariant: tones.muted,
          surfaceContainerLowest: tones.card,
          surfaceContainerLow: tones.card,
          surfaceContainer: tones.card,
          surfaceContainerHigh: tones.card,
          outlineVariant: tones.line,
          secondaryContainer: Color.alphaBlend(
            tones.gold.withValues(alpha: 0.30),
            tones.card,
          ),
          onSecondaryContainer: tones.ink,
        );
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    TextStyle? titled(TextStyle? style) => style?.copyWith(
      fontFamily: serif,
      fontWeight: FontWeight.w700,
      color: tones.ink,
    );
    return base.copyWith(
      extensions: [tones],
      scaffoldBackgroundColor: tones.paper,
      textTheme: base.textTheme.copyWith(
        headlineMedium: titled(base.textTheme.headlineMedium),
        headlineSmall: titled(base.textTheme.headlineSmall),
        titleLarge: titled(base.textTheme.titleLarge),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: tones.paper,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: titled(base.textTheme.titleLarge)
            ?.copyWith(fontSize: 21),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: tones.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: tones.line),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: tones.card,
        surfaceTintColor: Colors.transparent,
        indicatorColor: tones.gold.withValues(alpha: 0.28),
      ),
      dividerTheme: DividerThemeData(color: tones.line, space: 1),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: tones.lacquer,
        foregroundColor: tones.onLacquer,
      ),
    );
  }
}
