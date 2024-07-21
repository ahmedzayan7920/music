import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../di/dependency_injection.dart';
import '../../../logic/music_player_cubit/music_player_cubit.dart';
import '../../../logic/music_player_cubit/music_player_state.dart';
import '../artist_list_tile.dart';

class ArtistsList extends StatelessWidget {
  const ArtistsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
      buildWhen: (previous, current) =>
          current is MusicPlayerQueryArtistsSuccessState ||
          current is MusicPlayerQueryArtistsLoadingState ||
          current is MusicPlayerQueryArtistsErrorState,
      builder: (context, state) {
        if (state is MusicPlayerQueryArtistsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MusicPlayerQueryArtistsErrorState) {
          return Center(child: Text(state.message));
        }
        return RefreshIndicator(
          onRefresh: () async {
            getIt<MusicPlayerCubit>().queryAllArtists();
          },
          child: ListView.builder(
            itemCount: getIt<MusicPlayerCubit>().allArtists.length,
            itemBuilder: (context, index) {
              ArtistModel artist = getIt<MusicPlayerCubit>().allArtists[index];
              return ArtistListTile(artist: artist);
            },
          ),
        );
      },
    );
  }
}
