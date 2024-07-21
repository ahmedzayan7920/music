import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/dependency_injection.dart';
import '../../../logic/music_player_cubit/music_player_cubit.dart';
import '../../../logic/music_player_cubit/music_player_state.dart';

class HomeBottomNavigationBar extends StatelessWidget {
  const HomeBottomNavigationBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final musicPlayerCubit = getIt<MusicPlayerCubit>();
    return BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
      buildWhen: (previous, current) => current is MusicPlayerBottomNavState,
      builder: (context, state) {
        return BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note_outlined),
              label: "Songs",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.featured_play_list_outlined),
              label: "Playlists",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.album_outlined),
              label: "Albums",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: "Artists",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_outlined),
              label: "Favorites",
            ),
          ],
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: Colors.grey,
          currentIndex: musicPlayerCubit.currentBottomNavIndex,
          onTap: (value) {
            musicPlayerCubit.setCurrentBottomNavIndex(value);
          },
        );
      },
    );
  }
}
