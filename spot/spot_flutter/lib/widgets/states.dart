import 'package:flutter/material.dart';

import '../theme.dart';

/// Friendly full-area message for empty and error states.
class MessageState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const MessageState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Gap.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(Gap.md + 4),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: colors.primary),
            ),
            const SizedBox(height: Gap.md),
            Text(title, style: text.titleLarge, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: Gap.sm),
              Text(
                message!,
                style: text.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: Gap.lg),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Placeholder cards shown while a list loads.
class LoadingCards extends StatelessWidget {
  const LoadingCards({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(Gap.md),
      itemCount: 4,
      separatorBuilder: (_, _) => const SizedBox(height: Gap.md),
      itemBuilder: (_, _) => const SkeletonCard(),
    );
  }
}

/// A grey stand-in for an event card.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.06);
    Widget bar(double w, double h) => Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: base,
        borderRadius: BorderRadius.circular(8),
      ),
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Gap.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bar(90, 22),
            const SizedBox(height: Gap.md),
            bar(double.infinity, 22),
            const SizedBox(height: Gap.sm),
            bar(180, 16),
            const SizedBox(height: Gap.xs),
            bar(220, 16),
          ],
        ),
      ),
    );
  }
}

void showErrorSnackBar(BuildContext context, String message) {
  final colors = Theme.of(context).colorScheme;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: colors.onErrorContainer),
        ),
        backgroundColor: colors.errorContainer,
      ),
    );
}

void showInfoSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
