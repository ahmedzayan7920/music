import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../di/dependency_injection.dart';
import '../../logic/music_player_cubit/music_player_cubit.dart';
import '../screens/player_screen.dart';
import 'playlist_song_tile_trailing.dart';

class PlaylistSongListTile extends StatelessWidget {
  const PlaylistSongListTile({
    super.key,
    required this.songs,
    required this.index,
    required this.playlistId,
  });

  final List<SongModel> songs;
  final int index;
  final int playlistId;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        _showDeleteDialog(context, index);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(songs: songs, index: index),
          ),
        );
      },
      title: Text(songs[index].title,
          maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(songs[index].artist ?? "unknown",
          maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: PlaylistSongTileTrailing(
        playlistId: playlistId,
        songId: songs[index].id,
      ),
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Center(
          child: QueryArtworkWidget(
            controller: getIt(),
            id: songs[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Icon(Icons.music_note_outlined),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showDeleteDialog(BuildContext context, int index) {
    final musicPlayerCubit = getIt<MusicPlayerCubit>();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to delete this song?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                musicPlayerCubit.removeSongFromPlayList(
                    playlistId: playlistId,
                    songId: musicPlayerCubit.matchedSongs[index].id);
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
