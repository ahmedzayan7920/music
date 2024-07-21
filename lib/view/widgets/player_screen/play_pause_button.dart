import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../di/dependency_injection.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key, this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final audioPlayer = getIt<AudioPlayer>();
    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final processingState = snapshot.data?.processingState;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return const IconButton(
            onPressed: null,
            icon: Icon(Icons.play_arrow),
          );
        } else if (!audioPlayer.playing) {
          return IconButton(
            onPressed: audioPlayer.play,
            icon: const Icon(Icons.play_arrow),
            color: color,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            onPressed: audioPlayer.pause,
            icon: const Icon(Icons.pause),
            color: color,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            color: color,
            onPressed: () => audioPlayer.seek(
              Duration.zero,
              index: audioPlayer.effectiveIndices?.first,
            ),
          );
        }
      },
    );
  }
}
