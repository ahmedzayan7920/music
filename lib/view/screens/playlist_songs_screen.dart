import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../di/dependency_injection.dart';
import '../../logic/music_player_cubit/music_player_cubit.dart';
import '../../logic/music_player_cubit/music_player_state.dart';
import '../widgets/handle_future_builder.dart';
import '../widgets/mini_player.dart';
import '../widgets/playlist_song_list_tile.dart';
import '../widgets/playlist_songs_floating_action_button.dart';
import '../widgets/shuffle_list_tile.dart';

class PlaylistSongsScreen extends StatelessWidget {
  const PlaylistSongsScreen({
    super.key,
    required this.playlistId,
    required this.playlistName,
  });
  final int playlistId;
  final String playlistName;

  @override
  Widget build(BuildContext context) {
    final musicPlayerCubit = getIt<MusicPlayerCubit>();
    return BlocProvider.value(
      value: musicPlayerCubit,
      child: BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
        buildWhen: (previous, current) =>
            current is MusicPlayerAddRemovePlaylistSongState,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(playlistName),
            ),
            body: FutureBuilder<List<SongModel>>(
              future: getIt<OnAudioQuery>().queryAudiosFrom(
                AudiosFromType.PLAYLIST,
                playlistId,
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                ignoreCase: true,
              ),
              builder: (context, snapshot) {
                return HandleFutureBuilder(
                  snapshot: snapshot,
                  successWidgetFunction: () {
                    musicPlayerCubit.setupMatchedSongs(snapshot.data!);
                    return Column(
                      children: [
                        ShuffleListTile(songs: musicPlayerCubit.matchedSongs),
                        Expanded(
                          child: ListView.builder(
                            itemCount: musicPlayerCubit.matchedSongs.length,
                            itemBuilder: (context, index) {
                              List<SongModel> songs =
                                  musicPlayerCubit.matchedSongs;
                              return PlaylistSongListTile(
                                songs: songs,
                                index: index,
                                playlistId: playlistId,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            bottomNavigationBar: const MiniPlayer(),
            floatingActionButton:
                PlaylistSongsFloatingActionButton(playlistId: playlistId),
          );
        },
      ),
    );
  }
}
