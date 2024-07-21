import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../extensions/extensions.dart';
import 'music_player_state.dart';

class MusicPlayerCubit extends Cubit<MusicPlayerState> {
  final SharedPreferences _sharedPreferences;
  final AudioPlayer _audioPlayer;
  final OnAudioQuery _audioQuery;
  MusicPlayerCubit({
    required SharedPreferences sharedPreferences,
    required AudioPlayer audioPlayer,
    required OnAudioQuery audioQuery,
  })  : _sharedPreferences = sharedPreferences,
        _audioPlayer = audioPlayer,
        _audioQuery = audioQuery,
        super(MusicPlayerInitialState()) {
    initializeFavorites();
  }

  int _currentBottomNavIndex = 0;
  List<SongModel> _allSongs = [];
  List<PlaylistModel> _allPlaylists = [];
  List<AlbumModel> _allAlbums = [];
  List<ArtistModel> _allArtists = [];
  List<SongModel> _matchedSongs = [];
  List<int> _favoriteSongsIds = [];

  int get currentBottomNavIndex => _currentBottomNavIndex;
  List<SongModel> get allSongs => _allSongs;
  List<PlaylistModel> get allPlaylists => _allPlaylists;
  List<AlbumModel> get allAlbums => _allAlbums;
  List<ArtistModel> get allArtists => _allArtists;
  List<SongModel> get matchedSongs => _matchedSongs;

  List<int> get favoriteSongsIds => _favoriteSongsIds;

  setupMatchedSongs(List<SongModel> item) {
    List<SongModel> matchedSongs = [];
    for (var playlistSong in item) {
      for (var song in _allSongs) {
        if (playlistSong.title == song.title &&
            playlistSong.duration == song.duration) {
          matchedSongs.add(song);
          break;
        }
      }
    }
    _matchedSongs = matchedSongs;
  }

  toggleFavorite({required int id}) async {
    if (_favoriteSongsIds.contains(id)) {
      _favoriteSongsIds.remove(id);
    } else {
      _favoriteSongsIds.add(id);
    }
    emit(MusicPlayerAddRemoveFavoriteSongState());
    _sharedPreferences.setStringList(
        "favorites", _favoriteSongsIds.map((e) => e.toString()).toList());
  }

  initializeFavorites() async {
    _favoriteSongsIds = _sharedPreferences
            .getStringList("favorites")
            ?.map(
              (e) => int.parse(e),
            )
            .toList() ??
        [];
  }

  queryAllSongs() async {
    emit(MusicPlayerQuerySongsLoadingState());
    try {
      _allSongs = await _audioQuery.querySongs(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      emit(MusicPlayerQuerySongsSuccessState());
    } catch (error) {
      emit(MusicPlayerQuerySongsErrorState(message: error.toString()));
    }
  }

  queryAllPlaylists() async {
    emit(MusicPlayerQueryPlaylistsLoadingState());
    try {
      _allPlaylists = await _audioQuery.queryPlaylists(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      emit(MusicPlayerQueryPlaylistsSuccessState());
    } catch (error) {
      emit(MusicPlayerQueryPlaylistsErrorState(message: error.toString()));
    }
  }

  queryAllAlbums() async {
    emit(MusicPlayerQueryAlbumsLoadingState());
    try {
      _allAlbums = await _audioQuery.queryAlbums(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      emit(MusicPlayerQueryAlbumsSuccessState());
    } catch (error) {
      emit(MusicPlayerQueryAlbumsErrorState(message: error.toString()));
    }
  }

  queryAllArtists() async {
    emit(MusicPlayerQueryArtistsLoadingState());
    try {
      _allArtists = await _audioQuery.queryArtists(
        sortType: null,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      emit(MusicPlayerQueryArtistsSuccessState());
    } catch (error) {
      emit(MusicPlayerQueryArtistsErrorState(message: error.toString()));
    }
  }

  setCurrentBottomNavIndex(int index) {
    _currentBottomNavIndex = index;
    emit(MusicPlayerBottomNavState());
  }

  setAllSongs(List<SongModel> songs) {
    _allSongs = songs;
  }

  setAllPlaylists(List<PlaylistModel> playlists) {
    _allPlaylists = playlists;
  }

  setAllAlbums(List<AlbumModel> albums) {
    _allAlbums = albums;
  }

  setAllArtists(List<ArtistModel> artists) {
    _allArtists = artists;
  }

  addPlayList({required String name}) async {
    final success = await _audioQuery.createPlaylist(name);
    if (success) {
      await queryAllPlaylists();
      emit(MusicPlayerAddRemovePlaylistState());
    }
  }

  removePlayList({required int id}) async {
    final success = await _audioQuery.removePlaylist(id);
    if (success) {
      _allPlaylists.removeWhere((element) => element.id == id);
      emit(MusicPlayerAddRemovePlaylistState());
    }
  }

  addSongToPlayList({required int playlistId, required int songId}) async {
    final success = await _audioQuery.addToPlaylist(playlistId, songId);
    if (success) {
      await queryAllPlaylists();
      emit(MusicPlayerAddRemovePlaylistSongState());
    }
  }

  removeSongFromPlayList({required int playlistId, required int songId}) async {
    final success = await _audioQuery.removeFromPlaylist(playlistId, songId);
    if (success) {
      await queryAllPlaylists();
      emit(MusicPlayerAddRemovePlaylistSongState());
    }
  }

  Future<void> restoreAudioState() async {
    int currentPosition = _sharedPreferences.getInt('audio_position') ?? 0;
    int currentIndex = _sharedPreferences.getInt('current_index') ?? 0;
    bool shuffle = _sharedPreferences.getBool('shuffle') ?? false;
    String loop = _sharedPreferences.getString('loop') ?? "";
    String? savedSources = _sharedPreferences.getString('audio_source');

    if (savedSources != null) {
      List<dynamic> sourceList = jsonDecode(savedSources);
      List<UriAudioSource> sources = sourceList.map((source) {
        final sourceMap = source as Map<String, dynamic>;
        return AudioSource.uri(
          Uri.parse(sourceMap['uri'] as String),
          tag: (sourceMap['tag'] as Map<String, dynamic>).fromJson(),
        );
      }).toList();

      _audioPlayer.setShuffleModeEnabled(shuffle);
      _audioPlayer.setLoopMode(loop.toLoopMode());
      _audioPlayer.setAudioSource(
        ConcatenatingAudioSource(children: sources),
        initialIndex: currentIndex,
        initialPosition: Duration(milliseconds: currentPosition),
      );
    }
  }

  Future<void> saveAudioState() async {
    final audioSource = _audioPlayer.audioSource;
    if (audioSource != null && audioSource is ConcatenatingAudioSource) {
      List<Map<String, dynamic>> sources = [];
      for (var source in audioSource.children) {
        if (source is UriAudioSource) {
          sources.add({
            'uri': source.uri.toString(),
            'tag': (source.tag as MediaItem).toJson(),
          });
        }
      }
      _sharedPreferences.setString('audio_source', jsonEncode(sources));
    }
    _sharedPreferences.setInt(
        'audio_position', _audioPlayer.position.inMilliseconds);
    _sharedPreferences.setInt('current_index', _audioPlayer.currentIndex ?? 0);
    _sharedPreferences.setBool('shuffle', _audioPlayer.shuffleModeEnabled);
    _sharedPreferences.setString('loop', _audioPlayer.loopMode.toShortString());
  }
}
