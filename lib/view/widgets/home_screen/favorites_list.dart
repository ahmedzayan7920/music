import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../di/dependency_injection.dart';
import '../../../logic/music_player_cubit/music_player_cubit.dart';
import '../shuffle_list_tile.dart';
import '../song_list_tile.dart';

import '../../../logic/music_player_cubit/music_player_state.dart';

class FavoritesList extends StatelessWidget {
  const FavoritesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<MusicPlayerCubit>(),
      child: BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
        buildWhen: (previous, current) =>
            current is MusicPlayerAddRemoveFavoriteSongState,
        builder: (context, state) {
          final songs = getIt<MusicPlayerCubit>()
              .allSongs
              .where(
                (element) => getIt<MusicPlayerCubit>()
                    .favoriteSongsIds
                    .contains(element.id),
              )
              .toList();
          return Column(
            children: [
              songs.isEmpty ? const SizedBox() : ShuffleListTile(songs: songs),
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    return SongListTile(songs: songs, index: index);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
