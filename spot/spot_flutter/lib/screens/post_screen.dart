import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spot_client/spot_client.dart';

import '../client.dart';
import '../theme.dart';
import '../util/events_changed.dart';
import '../util/format.dart';
import '../widgets/category.dart';
import '../widgets/states.dart';
import 'event_detail_screen.dart';
import 'location_picker_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _capacity = TextEditingController(text: '10');

  EventCategory? _category;
  DateTime? _date;
  TimeOfDay? _time;
  PickedPlace? _place;

  /// Shown under fields that aren't text inputs, after a failed submit.
  bool _showPickerErrors = false;
  bool _submitting = false;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _capacity.dispose();
    super.dispose();
  }

  DateTime? get _startsAt {
    final d = _date, t = _time;
    if (d == null || t == null) return null;
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  String? get _whenError {
    if (_date == null || _time == null) return 'Pick a date and time';
    if (!_startsAt!.isAfter(DateTime.now())) return 'Pick a time in the future';
    return null;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _pickPlace() async {
    final picked = await Navigator.of(context).push<PickedPlace>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => LocationPickerScreen(initial: _place),
      ),
    );
    if (picked != null) setState(() => _place = picked);
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final fieldsValid = _formKey.currentState!.validate();
    setState(() => _showPickerErrors = true);
    if (!fieldsValid ||
        _category == null ||
        _whenError != null ||
        _place == null) {
      showErrorSnackBar(context, 'Please fill in the highlighted fields.');
      return;
    }

    setState(() => _submitting = true);
    try {
      final view = await client.event.createEvent(
        title: _title.text.trim(),
        description: _description.text.trim(),
        category: _category!,
        startsAt: _startsAt!.toUtc(),
        lat: _place!.lat,
        lng: _place!.lng,
        locationName: _place!.name,
        capacity: int.parse(_capacity.text),
      );
      if (!mounted) return;
      _reset();
      notifyEventsChanged();
      showInfoSnackBar(context, 'Your event is live!');
      await openEvent(context, view.event.id!, initial: view);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _reset() {
    _formKey.currentState!.reset();
    _title.clear();
    _description.clear();
    _capacity.text = '10';
    setState(() {
      _category = null;
      _date = null;
      _time = null;
      _place = null;
      _showPickerErrors = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Post an event')),
      body: Form(
        key: _formKey,
        // After the first failed submit, re-check fields as the user fixes them.
        autovalidateMode: _showPickerErrors
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(Gap.md, Gap.sm, Gap.md, Gap.xl),
          children: [
            Text(
              'Host a debate, a reading, a game night — anything in person.',
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: Gap.lg),
            TextFormField(
              controller: _title,
              maxLength: 80,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Add a title' : null,
            ),
            const SizedBox(height: Gap.sm),
            TextFormField(
              controller: _description,
              maxLength: 2000,
              minLines: 3,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'What will happen? Anything people should bring?',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: Gap.md),
            _Label('Category'),
            Wrap(
              spacing: Gap.sm,
              runSpacing: Gap.sm,
              children: [
                for (final c in EventCategory.values)
                  ChoiceChip(
                    selected: _category == c,
                    showCheckmark: false,
                    avatar: Icon(
                      c.icon,
                      size: 16,
                      color: _category == c
                          ? colors.onPrimary
                          : colors.onSurfaceVariant,
                    ),
                    label: Text(c.label),
                    labelStyle: TextStyle(
                      color: _category == c ? colors.onPrimary : null,
                    ),
                    selectedColor: colors.primary,
                    onSelected: (_) => setState(() => _category = c),
                  ),
              ],
            ),
            if (_showPickerErrors && _category == null)
              _ErrorText('Choose a category'),
            const SizedBox(height: Gap.lg),
            _Label('When'),
            Row(
              children: [
                Expanded(
                  child: _PickerTile(
                    icon: Icons.calendar_today_outlined,
                    label: _date == null
                        ? 'Date'
                        : DateFormat('EEE d MMM').format(_date!),
                    onTap: _pickDate,
                    hasError: _showPickerErrors && _date == null,
                  ),
                ),
                const SizedBox(width: Gap.sm + 4),
                Expanded(
                  child: _PickerTile(
                    icon: Icons.schedule,
                    label: _time == null ? 'Time' : _time!.format(context),
                    onTap: _pickTime,
                    hasError: _showPickerErrors && _time == null,
                  ),
                ),
              ],
            ),
            if (_showPickerErrors && _whenError != null)
              _ErrorText(_whenError!),
            const SizedBox(height: Gap.lg),
            _Label('Where'),
            _PickerTile(
              icon: Icons.place_outlined,
              label: _place?.name ?? 'Pick a location on the map',
              trailing: Icons.map_outlined,
              onTap: _pickPlace,
              hasError: _showPickerErrors && _place == null,
            ),
            if (_showPickerErrors && _place == null)
              _ErrorText('Pick where it happens'),
            const SizedBox(height: Gap.lg),
            TextFormField(
              controller: _capacity,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Capacity',
                helperText: 'How many people can join (not counting you)',
                prefixIcon: Icon(Icons.groups_outlined),
              ),
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 2) return 'At least 2 people';
                if (n > 500) return 'At most 500 people';
                return null;
              },
            ),
            const SizedBox(height: Gap.xl),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Text('Post event'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: Gap.sm),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}

class _ErrorText extends StatelessWidget {
  final String text;
  const _ErrorText(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: Gap.xs + 2, left: Gap.sm),
    child: Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
    ),
  );
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final IconData? trailing;
  final VoidCallback onTap;
  final bool hasError;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? const Color(0xFF221E19) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: hasError ? colors.error : colors.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Gap.md, vertical: 15),
          child: Row(
            children: [
              Icon(icon, size: 20, color: colors.onSurfaceVariant),
              const SizedBox(width: Gap.sm + 4),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailing != null)
                Icon(trailing, size: 20, color: colors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
