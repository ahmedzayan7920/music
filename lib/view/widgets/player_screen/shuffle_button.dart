import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../di/dependency_injection.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioPlayer = getIt<AudioPlayer>();
    return StreamBuilder<bool>(
      stream: audioPlayer.shuffleModeEnabledStream,
      builder: (context, snapshot) {
        bool isEnabled = snapshot.data ?? false;
        return IconButton(
          onPressed: () async {
            if (!isEnabled) {
              await audioPlayer.shuffle();
            }
            await audioPlayer.setShuffleModeEnabled(!isEnabled);
          },
          icon: const Icon(Icons.shuffle),
          color: isEnabled ? Theme.of(context).colorScheme.primary : null,
          splashColor: Colors.transparent,
        );
      },
    );
  }
}
