import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../di/dependency_injection.dart';
import '../../../logic/music_player_cubit/music_player_cubit.dart';
import '../../../logic/music_player_cubit/music_player_state.dart';
import '../add_remove_favorite_icon.dart';
import '../song_tile_trailing.dart';

class PlayerSongsList extends StatefulWidget {
  const PlayerSongsList({super.key});

  @override
  State<PlayerSongsList> createState() => _PlayerSongsListState();
}

class _PlayerSongsListState extends State<PlayerSongsList> {
  final ItemScrollController itemScrollController = ItemScrollController();
  int? previousIndex;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final audioPlayer = getIt<AudioPlayer>();
    return StreamBuilder<SequenceState?>(
      stream: audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final sequence = state?.sequence ?? [];
        currentIndex = state?.currentIndex ?? 0;
        // Only scroll if the current index has changed
        if (currentIndex != previousIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToPlayingSong(sequence.length);
          });
        }
        return ScrollablePositionedList.builder(
          itemScrollController: itemScrollController,
          itemCount: sequence.length,
          initialScrollIndex: currentIndex,
          initialAlignment: 0,
          itemBuilder: (context, index) {
            return ListTile(
              selected: index == currentIndex,
              leading: SizedBox(
                width: 50,
                height: 50,
                child: Center(
                  child: QueryArtworkWidget(
                    id: int.parse(sequence[index].tag.id),
                    type: ArtworkType.AUDIO,
                    nullArtworkWidget: const Icon(Icons.music_note),
                  ),
                ),
              ),
              title: Text(
                sequence[index].tag.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                audioPlayer.seek(Duration.zero, index: index);
              },
              trailing: SongTileTrailing(id: int.parse(sequence[index].tag.id)),
            );
          },
        );
      },
    );
  }

  void _scrollToPlayingSong(int sequenceLength) {
    if (currentIndex != previousIndex &&
        currentIndex >= 0 &&
        currentIndex < sequenceLength) {
      itemScrollController.jumpTo(
        index: currentIndex,
        // duration: const Duration(milliseconds: 500),
        alignment: 0,
      );
      previousIndex = currentIndex;
    }
  }
}
