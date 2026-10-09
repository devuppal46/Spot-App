import 'package:flutter/material.dart';

import '../widgets/states.dart';

/// Post a new event. Built out in Phase 8.
class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post an event')),
      body: const MessageState(
        icon: Icons.add_location_alt_outlined,
        title: 'Coming soon',
        message: 'Host your own debate, reading or game night.',
      ),
    );
  }
}
