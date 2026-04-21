import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/theme/app_theme.dart';
import 'src/l10n/app_strings.dart';
import 'src/l10n/locale_provider.dart';
import 'src/l10n/locale_storage.dart';
import 'src/widgets/app_logo.dart';
import 'src/screens/language_gate_screen.dart';
import 'src/screens/preferences_screen.dart';
import 'src/screens/duration_screen.dart';
import 'src/screens/itinerary_screen.dart';
import 'src/screens/control_panel_screen.dart';
import 'src/services/itinerary_service.dart';
import 'src/models/day_plan.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.surface,
    ),
  );
  runApp(const JExploreApp());
}

class JExploreApp extends StatefulWidget {
  const JExploreApp({super.key});

  @override
  State<JExploreApp> createState() => _JExploreAppState();
}

class _JExploreAppState extends State<JExploreApp> {
  bool _isArabic = true;
  bool _loadingLocale = true;

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final isAr = await loadIsArabic();
    if (mounted) {
      setState(() {
        _isArabic = isAr;
        _loadingLocale = false;
      });
    }
  }

  void _setLocale(bool isArabic) async {
    await saveIsArabic(isArabic);
    if (mounted) {
      setState(() => _isArabic = isArabic);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingLocale) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final strings = AppStrings(_isArabic);
    final textDir = _isArabic ? TextDirection.rtl : TextDirection.ltr;
    final locale = _isArabic ? const Locale('ar', 'SA') : const Locale('en', 'US');

    return MaterialApp(
      title: 'JExplore',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: const [
        Locale('ar', 'SA'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Directionality(
          textDirection: textDir,
          child: LocaleProvider(
            strings: strings,
            setLocale: _setLocale,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      home: const _AppHome(),
    );
  }
}

class _AppHome extends StatefulWidget {
  const _AppHome();

  @override
  State<_AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<_AppHome> {
  List<String>? _interests;
  int? _days;
  List<DayPlan> _plans = [];
  bool _loading = false;
  bool _showSplash = true;
  bool _languageGateLoaded = false;
  bool _languageGateCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadLanguageGateFlag();
  }

  Future<void> _loadLanguageGateFlag() async {
    final done = await loadLanguageGateCompleted();
    if (mounted) {
      setState(() {
        _languageGateCompleted = done;
        _languageGateLoaded = true;
      });
    }
  }

  Future<void> _buildItinerary(List<String> interests, int days) async {
    setState(() => _loading = true);
    try {
      final service = ItineraryService();
      final plans = await service.buildItinerary(
        interests: interests,
        daysCount: days,
      );
      if (mounted) {
        setState(() {
          _interests = interests;
          _days = days;
          _plans = plans;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = LocaleProvider.of(context);

    if (_showSplash && _plans.isEmpty && !_loading) {
      return _SplashScreen(
        onComplete: () => setState(() => _showSplash = false),
      );
    }

    if (!_languageGateLoaded && _plans.isEmpty && !_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_languageGateCompleted && _plans.isEmpty && !_loading) {
      return LanguageGateScreen(
        onDone: () => setState(() => _languageGateCompleted = true),
      );
    }

    if (_loading) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryBlue,
                Color(0xFF1A56B8),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppLogo(height: 56, colorFilter: Colors.white),
                const SizedBox(height: 48),
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  s.loadingItinerary,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_plans.isEmpty) {
      return PreferencesScreen(
        onComplete: (interests) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DurationScreen(
                interests: interests,
                onConfirm: (days) async {
                  await _buildItinerary(interests, days);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
            ),
          );
        },
      );
    }

    return ItineraryScreen(
      plans: _plans,
      onOpenControlPanel: () => _openControlPanel(context),
    );
  }

  void _openControlPanel(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ControlPanelScreen(
          currentInterests: _interests ?? [],
          currentDays: _days ?? 1,
          onReplan: (interests, days) async {
            await _buildItinerary(interests, days);
            if (!context.mounted) return;
            Navigator.pop(context);
            setState(() {});
          },
        ),
      ),
    );
  }
}

class _SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const _SplashScreen({required this.onComplete});

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = LocaleProvider.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryBlue,
              Color(0xFF1A56B8),
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppLogo(height: 100, colorFilter: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        s.exploreJeddah,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.95),
                              fontSize: 22,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
