import 'package:flutter/material.dart';

import 'package:e_maintenance/widget/TextStyling.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.actions = const <Widget>[],
    this.showBackButton = true,
    this.scrollable = true,
    this.padding = const EdgeInsets.fromLTRB(16, 6, 16, 18),
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;
  final bool showBackButton;
  final bool scrollable;
  final EdgeInsets padding;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Scaffold(
      backgroundColor: tokens.pageBackground,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              tokens.heroStart,
              tokens.pageBackground,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (showBackButton)
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                      ),
                    if (showBackButton) const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const AppBrandBlocks(height: 8),
                          const SizedBox(height: 10),
                          Text(title, style: context.textTheme.displayMedium),
                          if (subtitle != null) ...<Widget>[
                            const SizedBox(height: 4),
                            Text(subtitle!, style: context.textTheme.bodyMedium),
                          ],
                        ],
                      ),
                    ),
                    if (actions.isNotEmpty) ...<Widget>[
                      const SizedBox(width: 12),
                      Row(mainAxisSize: MainAxisSize.min, children: actions),
                    ],
                  ],
                ),
              ),
              Expanded(
                child: scrollable
                    ? SingleChildScrollView(
                        padding: padding,
                        physics: const BouncingScrollPhysics(),
                        child: child,
                      )
                    : Padding(
                        padding: padding,
                        child: child,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppBrandBlocks extends StatelessWidget {
  const AppBrandBlocks({
    super.key,
    this.height = 14,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Row(
      children: tokens.blockColors
          .map(
            (color) => Expanded(
              child: Container(
                height: height,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class AppSurfaceCard extends StatelessWidget {
  const AppSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.color,
    this.radius = 18,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? tokens.surface.withValues(alpha: context.isDarkMode ? 0.9 : 0.96),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: tokens.borderSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: tokens.shadow,
            blurRadius: 28,
            offset: const Offset(-8, 16),
          ),
        ],
      ),
      child: child,
    );
  }
}

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    required this.icon,
    this.color,
  });

  final String label;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final tone = color ?? tokens.brand;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: context.isDarkMode ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tone.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: tone),
          const SizedBox(width: 6),
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(color: tone),
          ),
        ],
      ),
    );
  }
}

class AppActionCard extends StatelessWidget {
  const AppActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.accentColor,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? accentColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final accent = accentColor ?? tokens.brand;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AppSurfaceCard(
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: context.textTheme.titleLarge),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 16, color: tokens.textMuted),
          ],
        ),
      ),
    );
  }
}

class AppSummaryItem extends StatelessWidget {
  const AppSummaryItem({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: context.textTheme.labelMedium?.copyWith(color: tokens.textMuted)),
        const SizedBox(height: 4),
        Text(value, style: context.textTheme.titleMedium),
      ],
    );
  }
}

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    this.action,
  });

  final String title;
  final String message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return AppSurfaceCard(
      child: Column(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: tokens.brandSoft.withValues(alpha: context.isDarkMode ? 0.35 : 0.8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, size: 26, color: tokens.brand),
          ),
          const SizedBox(height: 12),
          Text(title, style: context.textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(
            message,
            style: context.textTheme.bodyMedium?.copyWith(color: tokens.textMuted),
            textAlign: TextAlign.center,
          ),
          if (action != null) ...<Widget>[
            const SizedBox(height: 18),
            action!,
          ],
        ],
      ),
    );
  }
}

class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(strokeWidth: 2.6),
      ),
    );
  }
}
