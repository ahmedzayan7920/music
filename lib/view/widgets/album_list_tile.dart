import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../di/dependency_injection.dart';
import '../screens/songs_screen.dart';

class AlbumListTile extends StatelessWidget {
  const AlbumListTile({super.key, required this.album});
  final AlbumModel album;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongsScreen(
              audiosFromType: AudiosFromType.ALBUM,
              where: album.album,
            ),
          ),
        );
      },
      title: Text(album.album.toString(),
          maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text("${album.numOfSongs} songs",
          maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.arrow_forward_rounded),
      leading: SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: QueryArtworkWidget(
            controller: getIt(),
            id: album.id,
            type: ArtworkType.ALBUM,
            nullArtworkWidget: const Icon(Icons.album),
          ),
        ),
      ),
    );
  }
}
