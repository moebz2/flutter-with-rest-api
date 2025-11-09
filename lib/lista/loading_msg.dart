import 'package:flutter/material.dart';

class LoadingMsgWidget extends StatelessWidget {
  const LoadingMsgWidget({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}
