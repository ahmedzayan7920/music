import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../di/dependency_injection.dart';
import '../../logic/music_player_cubit/music_player_cubit.dart';

class PlaylistSongsFloatingActionButton extends StatelessWidget {
  const PlaylistSongsFloatingActionButton({
    super.key,
    required this.playlistId,
  });

  final int playlistId;

  @override
  Widget build(BuildContext context) {
    final musicPlayerCubit = getIt<MusicPlayerCubit>();
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final allSongs = musicPlayerCubit.allSongs;
            return Dialog(
              child: SizedBox(
                height: 400,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ListView.builder(
                    itemCount: allSongs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          allSongs[index].title,
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
                              id: allSongs[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Icon(Icons.music_note),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (musicPlayerCubit.matchedSongs.contains(allSongs[index])) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text("Song already Exists"),
                                ),
                              );
                          } else {
                            musicPlayerCubit.addSongToPlayList(
                              playlistId: playlistId,
                              songId: allSongs[index].id,
                            );
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
      child: const Icon(Icons.add),
    );
  }
}
