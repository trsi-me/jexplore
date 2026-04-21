import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/locale_provider.dart';
import '../widgets/app_logo.dart';

/// شاشة تحديد مدة الإقامة
class DurationScreen extends StatefulWidget {
  final List<String> interests;
  final Function(int) onConfirm;

  const DurationScreen({
    super.key,
    required this.interests,
    required this.onConfirm,
  });

  @override
  State<DurationScreen> createState() => _DurationScreenState();
}

class _DurationScreenState extends State<DurationScreen> {
  int _selectedDays = 1;

  void _confirm() {
    widget.onConfirm(_selectedDays);
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                    ),
                    const Expanded(
                      child: AppLogo(height: 44, colorFilter: Colors.white),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          s.daysQuestion,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          s.selectDuration,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 28),
                        Expanded(
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.4,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              final days = index + 1;
                              final isSelected = _selectedDays == days;
                              return Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => setState(() => _selectedDays = days),
                                  borderRadius: BorderRadius.circular(20),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 220),
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
                                              ? AppColors.primaryBlue
                                                  .withValues(alpha: 0.35)
                                              : Colors.black
                                                  .withValues(alpha: 0.06),
                                          blurRadius: isSelected ? 12 : 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '$days',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge
                                              ?.copyWith(
                                                color: isSelected
                                                    ? Colors.white
                                                    : AppColors.textPrimary,
                                                fontSize: 36,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          days == 1 ? s.day : s.days,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                color: isSelected
                                                    ? Colors.white
                                                        .withValues(alpha: 0.95)
                                                    : AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _confirm,
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
                              Text(s.confirmAndBuild),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.calendar_month,
                                size: 22,
                                color: Colors.white.withValues(alpha: 0.95),
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
    );
  }
}
