import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'logic/app_cubit/app_cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'di/dependency_injection.dart';
import 'logic/app_cubit/app_state.dart';
import 'logic/music_player_cubit/music_player_cubit.dart';
import 'theming/app_themes.dart';
import 'view/screens/home_screen.dart';
import 'view/screens/permissions_screen.dart';

bool _hasPermission = false;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await initDependencyInjection();
  await getIt<MusicPlayerCubit>().restoreAudioState();
  _hasPermission = await getIt<OnAudioQuery>().permissionsStatus();
  _initListener();
  // testing
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppCubit>(),
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (previous, current) =>
            current is AppDarkState || current is AppLightState,
        builder: (context, state) {
          return MaterialApp(
            title: "Music Vibe",
            debugShowCheckedModeBanner: false,
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode:
                getIt<AppCubit>().isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home:
                _hasPermission ? const HomeScreen() : const PermissionsScreen(),
          );
        },
      ),
    );
  }
}

void _initListener() {
  getIt<AudioPlayer>().playerStateStream.listen((event) async {
    if (event.processingState == ProcessingState.idle ||
        event.playing == false) {
      getIt<MusicPlayerCubit>().saveAudioState();
    }
  });
}
