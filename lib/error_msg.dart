import 'package:flutter/material.dart';

class ErrorMsgWidget extends StatelessWidget {
  final VoidCallback onRetry;
  final String? message;

  const ErrorMsgWidget({
    super.key,
    required this.onRetry,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(message ?? 'Failed to load Pokémon'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}