import 'package:flutter/material.dart';

@immutable
sealed class MusicPlayerState {}

final class MusicPlayerInitialState extends MusicPlayerState {}

final class MusicPlayerBottomNavState extends MusicPlayerState {}

final class MusicPlayerQuerySongsLoadingState extends MusicPlayerState {}

final class MusicPlayerQuerySongsSuccessState extends MusicPlayerState {}

final class MusicPlayerQuerySongsErrorState extends MusicPlayerState {
  final String message;

  MusicPlayerQuerySongsErrorState({required this.message});
}

final class MusicPlayerQueryPlaylistsLoadingState extends MusicPlayerState {}

final class MusicPlayerQueryPlaylistsSuccessState extends MusicPlayerState {}

final class MusicPlayerQueryPlaylistsErrorState extends MusicPlayerState {
  final String message;

  MusicPlayerQueryPlaylistsErrorState({required this.message});
}

final class MusicPlayerQueryAlbumsLoadingState extends MusicPlayerState {}

final class MusicPlayerQueryAlbumsSuccessState extends MusicPlayerState {}

final class MusicPlayerQueryAlbumsErrorState extends MusicPlayerState {
  final String message;

  MusicPlayerQueryAlbumsErrorState({required this.message});
}

final class MusicPlayerQueryArtistsLoadingState extends MusicPlayerState {}

final class MusicPlayerQueryArtistsSuccessState extends MusicPlayerState {}

final class MusicPlayerQueryArtistsErrorState extends MusicPlayerState {
  final String message;

  MusicPlayerQueryArtistsErrorState({required this.message});
}

final class MusicPlayerAddRemovePlaylistState extends MusicPlayerState {}

final class MusicPlayerAddRemovePlaylistSongState extends MusicPlayerState {}

final class MusicPlayerAddRemoveFavoriteSongState extends MusicPlayerState {}
