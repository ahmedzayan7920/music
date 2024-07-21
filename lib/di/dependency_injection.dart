import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music/logic/app_cubit/app_cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logic/music_player_cubit/music_player_cubit.dart';

var getIt = GetIt.instance;

initDependencyInjection() async {
  getIt.registerFactory<OnAudioQuery>(() => OnAudioQuery());
  getIt.registerLazySingleton<AudioPlayer>(() => AudioPlayer());

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  getIt.registerLazySingleton<MusicPlayerCubit>(
    () => MusicPlayerCubit(
      sharedPreferences: getIt(),
      audioPlayer: getIt(),
      audioQuery: getIt(),
    ),
  );
  getIt.registerLazySingleton<AppCubit>(
    () => AppCubit(
      sharedPreferences: getIt(),
    ),
  );
}
