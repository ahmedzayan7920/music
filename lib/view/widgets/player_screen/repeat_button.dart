import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../di/dependency_injection.dart';

class RepeatButton extends StatelessWidget {
  const RepeatButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayer = getIt<AudioPlayer>();
    return StreamBuilder<LoopMode>(
      stream: audioPlayer.loopModeStream,
      builder: (context, snapshot) {
        final loopMode = snapshot.data ?? LoopMode.off;
        final icons = [
          const Icon(Icons.repeat),
          Icon(Icons.repeat, color: Theme.of(context).colorScheme.primary),
          Icon(Icons.repeat_one, color: Theme.of(context).colorScheme.primary),
        ];

        const repeatModes = [
          LoopMode.off,
          LoopMode.all,
          LoopMode.one,
        ];

        final index = repeatModes.indexOf(loopMode);

        return IconButton(
          icon: icons[index],
          onPressed: () {
            audioPlayer.setLoopMode(
              repeatModes[(index + 1) % repeatModes.length],
            );
          },
        );
      },
    );
  }
}
