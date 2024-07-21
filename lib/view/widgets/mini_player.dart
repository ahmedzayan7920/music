import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../di/dependency_injection.dart';
import '../screens/player_screen.dart';
import 'player_screen/play_pause_button.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: getIt<AudioPlayer>().sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final sequence = state?.sequence ?? [];
        final index = state?.currentIndex ?? 0;

        if (sequence.isEmpty || index >= sequence.length) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            tileColor: Theme.of(context).colorScheme.primary,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(
                    songs: const [],
                    index: index,
                    reOpen: true,
                  ),
                ),
              );
            },
            leading: SizedBox(
              width: 50,
              height: 50,
              child: Center(
                child: QueryArtworkWidget(
                  id: int.parse(sequence[index].tag.id),
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: Text(
              sequence[index].tag.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              sequence[index].tag.artist ?? "unknown",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: const PlayPauseButton(color: Colors.white),
          ),
        );
      },
    );
  }
}
