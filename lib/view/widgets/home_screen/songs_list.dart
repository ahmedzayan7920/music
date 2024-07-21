import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music/di/dependency_injection.dart';

import '../../../logic/music_player_cubit/music_player_cubit.dart';
import '../../../logic/music_player_cubit/music_player_state.dart';
import '../shuffle_list_tile.dart';
import '../song_list_tile.dart';

class SongsList extends StatelessWidget {
  const SongsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
      buildWhen: (previous, current) =>
          current is MusicPlayerQuerySongsSuccessState ||
          current is MusicPlayerQuerySongsLoadingState ||
          current is MusicPlayerQuerySongsErrorState,
      builder: (context, state) {
        if (state is MusicPlayerQuerySongsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MusicPlayerQuerySongsErrorState) {
          return Center(child: Text(state.message));
        }
        return Column(
          children: [
            ShuffleListTile(songs: getIt<MusicPlayerCubit>().allSongs),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  getIt<MusicPlayerCubit>().queryAllSongs();
                },
                child: ListView.builder(
                  itemCount: getIt<MusicPlayerCubit>().allSongs.length,
                  itemBuilder: (context, index) {
                    return SongListTile(
                        songs: getIt<MusicPlayerCubit>().allSongs,
                        index: index);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
