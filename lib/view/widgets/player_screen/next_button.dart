import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../di/dependency_injection.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayer = getIt<AudioPlayer>();
    return StreamBuilder<SequenceState?>(
      stream: audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        return IconButton(
          onPressed: audioPlayer.hasNext
              ? audioPlayer.seekToNext
              : null,
          icon: const Icon(Icons.skip_next),
        );
      },
    );
  }
}