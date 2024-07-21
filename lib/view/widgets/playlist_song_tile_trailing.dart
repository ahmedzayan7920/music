import 'package:flutter/material.dart';
import 'package:music/di/dependency_injection.dart';
import 'package:music/logic/music_player_cubit/music_player_cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'add_remove_favorite_icon.dart';

class PlaylistSongTileTrailing extends StatelessWidget {
  const PlaylistSongTileTrailing({
    super.key,
    required this.songId,
    required this.playlistId,
  });

  final int songId;
  final int playlistId;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AddRemoveFavoriteIcon(id: songId),
        PopupMenuButton(
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: ListTile(
                  title: const Text("Remove from this playlist"),
                  onTap: () {
                    getIt<MusicPlayerCubit>().removeSongFromPlayList(
                      playlistId: playlistId,
                      songId: songId,
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              PopupMenuItem(
                child: ListTile(
                  title: const Text("Add to Playlist"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        final allPlaylists =
                            getIt<MusicPlayerCubit>().allPlaylists;
                        return Dialog(
                          child: SizedBox(
                            height: 400,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ListView.builder(
                                itemCount: allPlaylists.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                      allPlaylists[index].playlist,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    leading: SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Center(
                                        child: QueryArtworkWidget(
                                          quality: 100,
                                          controller: getIt(),
                                          id: allPlaylists[index].id,
                                          type: ArtworkType.PLAYLIST,
                                          nullArtworkWidget: const Icon(Icons
                                              .featured_play_list_outlined),
                                        ),
                                      ),
                                    ),
                                    onTap: () async {
                                      List<SongModel> playlistSongs =
                                          await getIt<OnAudioQuery>()
                                              .queryAudiosFrom(
                                        AudiosFromType.PLAYLIST,
                                        allPlaylists[index].id,
                                        sortType: null,
                                        orderType: OrderType.ASC_OR_SMALLER,
                                        ignoreCase: true,
                                      );

                                      getIt<MusicPlayerCubit>()
                                          .setupMatchedSongs(playlistSongs);

                                      List<SongModel> match =
                                          getIt<MusicPlayerCubit>()
                                              .matchedSongs
                                              .where((element) =>
                                                  element.id == songId)
                                              .toList();
                                      if (match.isNotEmpty) {
                                        ScaffoldMessenger.of(context)
                                          ..hideCurrentSnackBar()
                                          ..showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text("Song already Exists"),
                                            ),
                                          );
                                      } else {
                                        getIt<MusicPlayerCubit>()
                                            .addSongToPlayList(
                                          playlistId: allPlaylists[index].id,
                                          songId: songId,
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ];
          },
        ),
      ],
    );
  }
}
