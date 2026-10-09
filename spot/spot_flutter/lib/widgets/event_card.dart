import 'package:flutter/material.dart';
import 'package:spot_client/spot_client.dart';

import '../theme.dart';
import '../util/format.dart';
import 'category.dart';

class EventCard extends StatelessWidget {
  final EventView view;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.view, this.onTap});

  @override
  Widget build(BuildContext context) {
    final e = view.event;
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isCancelled = e.status == EventStatus.cancelled;
    final isFull = view.spotsLeft == 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Gap.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CategoryTag(e.category),
                  if (view.joinedByMe && !isCancelled) ...[
                    const SizedBox(width: Gap.xs + 2),
                    _Pill(label: 'Going', color: colors.primary, filled: true),
                  ],
                  const Spacer(),
                  if (view.distanceKm != null)
                    _Meta(
                      icon: Icons.near_me_outlined,
                      label: formatDistance(view.distanceKm),
                    ),
                ],
              ),
              const SizedBox(height: Gap.sm + 4),
              Text(
                e.title,
                style: text.titleLarge?.copyWith(height: 1.2),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: Gap.sm),
              _Meta(icon: Icons.schedule, label: formatWhen(e.startsAt)),
              const SizedBox(height: Gap.xs),
              _Meta(icon: Icons.place_outlined, label: e.locationName),
              const SizedBox(height: Gap.md),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Hosted by ${view.hostedByMe ? 'you' : e.hostName}',
                      style: text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: Gap.sm),
                  _Pill(
                    label: spotsLeftLabel(view),
                    color: isCancelled || isFull
                        ? colors.error
                        : colors.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Meta({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: colors.onSurfaceVariant),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;
  const _Pill({required this.label, required this.color, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? color : null,
        borderRadius: BorderRadius.circular(99),
        border: filled ? null : Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: filled ? Colors.white : color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
