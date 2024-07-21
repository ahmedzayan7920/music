import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

extension MediaItemExtensions on MediaItem {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'artUri': artUri?.toString(),
      'duration': duration?.inMilliseconds,
    };
  }
}

extension StringExtensions on String {
  LoopMode toLoopMode() {
    switch (this) {
      case 'one':
        return LoopMode.one;
      case 'all':
        return LoopMode.all;
      default:
        return LoopMode.off;
    }
  }
}

extension MapExtensions on Map<String, dynamic> {
  MediaItem fromJson() {
    return MediaItem(
      id: this['id'],
      album: this['album'],
      title: this['title'],
      artist: this['artist'],
      duration: this['duration'] != null
          ? Duration(milliseconds: this['duration'])
          : null,
      artUri: this['artUri'] != null ? Uri.parse(this['artUri']) : null,
    );
  }
}

extension LoopModeExtensions on LoopMode {
  String toShortString() {
    switch (this) {
      case LoopMode.one:
        return 'one';
      case LoopMode.all:
        return 'all';
      default:
        return 'off';
    }
  }
}
