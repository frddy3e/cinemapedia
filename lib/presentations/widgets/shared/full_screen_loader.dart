import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessage() {
    final message = <String>[
      'Loading...',
      'Please wait...',
      'Just a moment...',
      'Almost there...',
      'Just a sec...',
      'Hold on...',
      'It is taking longer than expected...',
    ];
    return Stream.periodic(
            const Duration(seconds: 1), (x) => message[x % message.length])
        .take(message.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Loading...'),
        const SizedBox(height: 20),
        const CircularProgressIndicator(strokeWidth: 2),
        StreamBuilder(
            stream: getLoadingMessage(),
            builder: (context, snapshot) {
              return Text(snapshot.data ?? '');
            }),
      ],
    ));
  }
}
