import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../di/dependency_injection.dart';
import '../screens/player_screen.dart';
import 'song_tile_trailing.dart';

class SongListTile extends StatelessWidget {
  const SongListTile({
    super.key,
    required this.songs,
    required this.index,
  });
  final List<SongModel> songs;
  final int index;
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      trailing: SongTileTrailing(id: songs[index].id),
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Center(
          child: QueryArtworkWidget(
            controller: getIt(),
            id: songs[index].id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Icon(Icons.music_note),
          ),
        ),
      ),
    );
  }
}
