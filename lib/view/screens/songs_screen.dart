import 'package:flutter/material.dart';
import '../../di/dependency_injection.dart';
import '../widgets/mini_player.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../widgets/handle_future_builder.dart';
import '../widgets/shuffle_list_tile.dart';
import '../widgets/song_list_tile.dart';

class SongsScreen extends StatelessWidget {
  const SongsScreen({
    super.key,
    required this.audiosFromType,
    required this.where,
  });
  final AudiosFromType audiosFromType;
  final String where;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(where),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: getIt<OnAudioQuery>().queryAudiosFrom(
          audiosFromType,
          where,
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          ignoreCase: true,
        ),
        builder: (context, snapshot) {
          return HandleFutureBuilder(
            snapshot: snapshot,
            successWidgetFunction: () {
              return Column(
                children: [
                  ShuffleListTile(songs: snapshot.data!),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return SongListTile(
                            songs: snapshot.data!, index: index);
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
    );
  }
}
