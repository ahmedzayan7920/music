import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../di/dependency_injection.dart';
import '../../../logic/music_player_cubit/music_player_cubit.dart';
import '../../../logic/music_player_cubit/music_player_state.dart';
import '../playlist_list_tile.dart';

class PlaylistsList extends StatelessWidget {
  const PlaylistsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
      buildWhen: (previous, current) =>
          current is MusicPlayerQueryPlaylistsSuccessState ||
          current is MusicPlayerQueryPlaylistsLoadingState ||
          current is MusicPlayerQueryPlaylistsErrorState ||
          current is MusicPlayerAddRemovePlaylistState ||
          current is MusicPlayerAddRemovePlaylistSongState,
      builder: (context, state) {
        if (state is MusicPlayerQueryPlaylistsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MusicPlayerQueryPlaylistsErrorState) {
          return Center(child: Text(state.message));
        }
        return RefreshIndicator(
          onRefresh: () async {
            getIt<MusicPlayerCubit>().queryAllPlaylists();
          },
          child: ListView.builder(
            itemCount: getIt<MusicPlayerCubit>().allPlaylists.length,
            itemBuilder: (context, index) {
              PlaylistModel playlist =
                  getIt<MusicPlayerCubit>().allPlaylists[index];
              return PlaylistListTile(playlist: playlist);
            },
          ),
        );
      },
    );
  }
}
