import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../di/dependency_injection.dart';
import '../../../logic/music_player_cubit/music_player_cubit.dart';
import '../../../logic/music_player_cubit/music_player_state.dart';
import '../album_list_tile.dart';

class AlbumsList extends StatelessWidget {
  const AlbumsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
      buildWhen: (previous, current) =>
          current is MusicPlayerQueryAlbumsSuccessState ||
          current is MusicPlayerQueryAlbumsLoadingState ||
          current is MusicPlayerQueryAlbumsErrorState,
      builder: (context, state) {
        if (state is MusicPlayerQueryAlbumsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MusicPlayerQueryAlbumsErrorState) {
          return Center(child: Text(state.message));
        }
        return RefreshIndicator(
          onRefresh: () async {
            getIt<MusicPlayerCubit>().queryAllAlbums();
          },
          child: ListView.builder(
            itemCount: getIt<MusicPlayerCubit>().allAlbums.length,
            itemBuilder: (context, index) {
              AlbumModel album = getIt<MusicPlayerCubit>().allAlbums[index];
              return AlbumListTile(album: album);
            },
          ),
        );
      },
    );
  }
}
