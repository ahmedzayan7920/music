import 'package:flutter/material.dart';

class HandleFutureBuilder extends StatelessWidget {
  const HandleFutureBuilder({super.key, required this.snapshot, required this.successWidgetFunction});
  final AsyncSnapshot<List> snapshot;
  final Widget Function() successWidgetFunction;

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (snapshot.hasError) {
      return Center(
        child: Text('Error: ${snapshot.error}'),
      );
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(
        child: Text('Nothing found!'),
      );
    } else {
      return successWidgetFunction();
    }
  }
}
