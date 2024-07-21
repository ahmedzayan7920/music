import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../di/dependency_injection.dart';
import '../../logic/music_player_cubit/music_player_cubit.dart';
import '../screens/playlist_songs_screen.dart';

class PlaylistListTile extends StatelessWidget {
  const PlaylistListTile({super.key, required this.playlist});
  final PlaylistModel playlist;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        _showDeleteDialog(context);
      },
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaylistSongsScreen(
              playlistId: playlist.id,
              playlistName: playlist.playlist,
            ),
          ),
        );
      },
      title: Text(
        playlist.playlist.toString(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "${playlist.numOfSongs} songs",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(Icons.arrow_forward_rounded),
      leading: SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: QueryArtworkWidget(
            controller: getIt(),
            id: playlist.id,
            type: ArtworkType.PLAYLIST,
            nullArtworkWidget: const Icon(Icons.featured_play_list_outlined),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showDeleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete"),
          content: const Text("Are you sure you want to delete this playlist?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                getIt<MusicPlayerCubit>().removePlayList(id: playlist.id);
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
