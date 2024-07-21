import 'package:flutter/material.dart';
import '../../di/dependency_injection.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../screens/songs_screen.dart';

class ArtistListTile extends StatelessWidget {
  const ArtistListTile({super.key, required this.artist});
  final ArtistModel artist;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SongsScreen(
              audiosFromType: AudiosFromType.ARTIST,
              where: artist.artist,
            ),
          ),
        );
      },
      title: Text(artist.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text("${artist.numberOfTracks} songs",
          maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.arrow_forward_rounded),
      leading: SizedBox(
        width: 50,
        height: 50,
        child: Center(
          child: QueryArtworkWidget(
            controller: getIt(),
            id: artist.id,
            type: ArtworkType.ARTIST,
            nullArtworkWidget: const Icon(Icons.person),
          ),
        ),
      ),
    );
  }
}
