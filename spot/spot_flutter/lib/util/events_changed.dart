import 'package:flutter/foundation.dart';

/// Bumped whenever the user creates, joins, leaves or cancels an event, so
/// screens kept alive in the bottom nav (Home, My Events) can reload.
final eventsChanged = ValueNotifier<int>(0);

void notifyEventsChanged() => eventsChanged.value++;
