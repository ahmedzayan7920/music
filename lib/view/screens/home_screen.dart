import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/home_screen/favorites_list.dart';

import '../../di/dependency_injection.dart';
import '../../logic/music_player_cubit/music_player_cubit.dart';
import '../../logic/music_player_cubit/music_player_state.dart';
import '../widgets/dark_light_switch.dart';
import '../widgets/home_screen/albums_list.dart';
import '../widgets/home_screen/artists_list.dart';
import '../widgets/home_screen/home_bottom_navigation_bar.dart';
import '../widgets/home_screen/home_floating_action_button.dart';
import '../widgets/home_screen/playlists_list.dart';
import '../widgets/home_screen/search_button.dart';
import '../widgets/home_screen/songs_list.dart';
import '../widgets/mini_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final musicPlayerCubit = getIt<MusicPlayerCubit>();
    return BlocProvider(
      lazy: false,
      create: (context) => musicPlayerCubit
        ..queryAllSongs()
        ..queryAllPlaylists()
        ..queryAllAlbums()
        ..queryAllArtists(),
      child: BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
        buildWhen: (previous, current) => current is MusicPlayerBottomNavState,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              leadingWidth: 72,
              leading: const DarkLightSwitch(),
              title: const Text("Music Vibe"),
              actions: const [SearchButton()],
            ),
            body: [
              const SongsList(),
              const PlaylistsList(),
              const AlbumsList(),
              const ArtistsList(),
              const FavoritesList(),
            ][musicPlayerCubit.currentBottomNavIndex],
            bottomNavigationBar: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                MiniPlayer(),
                HomeBottomNavigationBar(),
              ],
            ),
            floatingActionButton: musicPlayerCubit.currentBottomNavIndex == 1
                ? const HomeFloatingActionButton()
                : null,
          );
        },
      ),
    );
  }
}
