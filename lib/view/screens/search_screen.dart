import 'package:flutter/material.dart';
import '../../di/dependency_injection.dart';
import '../../logic/music_player_cubit/music_player_cubit.dart';
import '../widgets/mini_player.dart';
import '../widgets/song_list_tile.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<SongModel> songs = getIt<MusicPlayerCubit>().allSongs;

  getSearchSongs(String query) async {
    songs = getIt<MusicPlayerCubit>()
        .allSongs
        .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Column(
        children: [
          Padding(
        padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              onChanged: (value) {
                getSearchSongs(value);
              },
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.search, color: theme.colorScheme.onSurface),
                hintText: 'Search for songs...',
                hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                return SongListTile(songs: songs, index: index);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const MiniPlayer(),
    );
  }
}
