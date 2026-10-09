import 'package:flutter/material.dart';
import 'package:spot_client/spot_client.dart';

extension EventCategoryUi on EventCategory {
  String get label => switch (this) {
    EventCategory.debate => 'Debate',
    EventCategory.bookReading => 'Book reading',
    EventCategory.games => 'Games',
    EventCategory.festive => 'Festive',
    EventCategory.other => 'Other',
  };

  IconData get icon => switch (this) {
    EventCategory.debate => Icons.forum_outlined,
    EventCategory.bookReading => Icons.menu_book_outlined,
    EventCategory.games => Icons.casino_outlined,
    EventCategory.festive => Icons.celebration_outlined,
    EventCategory.other => Icons.auto_awesome_outlined,
  };
}

/// Small, non-interactive pill showing an event's category.
class CategoryTag extends StatelessWidget {
  final EventCategory category;
  const CategoryTag(this.category, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(category.icon, size: 14, color: colors.primary),
          const SizedBox(width: 4),
          Text(
            category.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontally scrolling "All / Debate / Book reading / …" filter.
class CategoryFilterBar extends StatelessWidget {
  final EventCategory? selected;
  final ValueChanged<EventCategory?> onChanged;

  const CategoryFilterBar({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip(context, null, 'All', Icons.apps),
          for (final c in EventCategory.values)
            _chip(context, c, c.label, c.icon),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context,
    EventCategory? value,
    String label,
    IconData icon,
  ) {
    final isSelected = selected == value;
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        showCheckmark: false,
        avatar: Icon(
          icon,
          size: 16,
          color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
        ),
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? colors.onPrimary : colors.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        selectedColor: colors.primary,
        side: isSelected ? BorderSide.none : null,
        onSelected: (_) => onChanged(value),
      ),
    );
  }
}
