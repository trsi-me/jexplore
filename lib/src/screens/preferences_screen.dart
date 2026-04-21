import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/locale_provider.dart';
import '../widgets/app_logo.dart';

/// شاشة تحديد الاهتمامات السياحية
class PreferencesScreen extends StatefulWidget {
  final List<String>? initialInterests;
  final Function(List<String>) onComplete;

  const PreferencesScreen({
    super.key,
    this.initialInterests,
    required this.onComplete,
  });

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<String> _interests = [
    'مطاعم',
    'فنادق',
    'معالم سياحية',
    'فعاليات',
    'أماكن ترفيهية',
    'طبيعة',
    'تسوق',
  ];

  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = (widget.initialInterests != null)
        ? Set.from(widget.initialInterests!)
        : {};
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle(String item) {
    setState(() {
      if (_selected.contains(item)) {
        _selected.remove(item);
      } else {
        _selected.add(item);
      }
    });
  }

  void _next() {
    if (_selected.isEmpty) return;
    widget.onComplete(_selected.toList());
  }

  @override
  Widget build(BuildContext context) {
    final s = LocaleProvider.of(context);

    return Scaffold(
      body: Container(
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
            animation: _animController,
            builder: (context, child) => Opacity(
              opacity: _fadeAnim.value,
              child: child,
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                const AppLogo(height: 56, colorFilter: Colors.white),
              const SizedBox(height: 8),
              Text(
                s.welcomeToJeddah,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 20,
                        offset: Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          s.interestsQuestion,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          s.selectOneOrMore,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: _interests.map((item) {
                            final isSelected = _selected.contains(item);
                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _toggle(item),
                                borderRadius: BorderRadius.circular(20),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? const LinearGradient(
                                            colors: [
                                              AppColors.primaryBlue,
                                              Color(0xFF1A56B8),
                                            ],
                                          )
                                        : null,
                                    color: isSelected ? null : AppColors.surface,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected
                                            ? AppColors.primaryBlue.withValues(alpha: 0.35)
                                            : Colors.black.withValues(alpha: 0.06),
                                        blurRadius: isSelected ? 12 : 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isSelected)
                                        Padding(
                                          padding: EdgeInsetsDirectional.only(start: 8),
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      Text(
                                        s.categoryKey(item),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: isSelected
                                                  ? Colors.white
                                                  : AppColors.textPrimary,
                                              fontWeight:
                                                  isSelected ? FontWeight.w700 : FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 32),
                        FilledButton(
                          onPressed: _selected.isNotEmpty ? _next : null,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            backgroundColor: AppColors.secondaryTeal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(s.continueBtn),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward,
                                size: 22,
                                color: _selected.isNotEmpty
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
