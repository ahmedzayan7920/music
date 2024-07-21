import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/dependency_injection.dart';
import '../../logic/music_player_cubit/music_player_cubit.dart';
import '../../logic/music_player_cubit/music_player_state.dart';

class AddRemoveFavoriteIcon extends StatelessWidget {
  const AddRemoveFavoriteIcon({
    super.key,
    required this.id,
  });

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<MusicPlayerCubit>(),
      child: BlocBuilder<MusicPlayerCubit, MusicPlayerState>(
        buildWhen: (previous, current) =>
            current is MusicPlayerAddRemoveFavoriteSongState,
        builder: (context, state) {
          return IconButton(
            onPressed: () {
              getIt<MusicPlayerCubit>().toggleFavorite(
                id: id,
              );
            },
            icon: Icon(
              getIt<MusicPlayerCubit>().favoriteSongsIds.contains(id)
                  ? Icons.favorite
                  : Icons.favorite_outline,
            ),
          );
        },
      ),
    );
  }
}
