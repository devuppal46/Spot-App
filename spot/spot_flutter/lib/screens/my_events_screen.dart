import 'package:flutter/material.dart';

import '../widgets/states.dart';

/// Events you host and have joined. Built out in Phase 9.
class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My events')),
      body: const MessageState(
        icon: Icons.event_note_outlined,
        title: 'Coming soon',
        message: "Events you're hosting and attending will show up here.",
      ),
    );
  }
}
