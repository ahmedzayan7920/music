import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/dependency_injection.dart';
import '../../logic/app_cubit/app_cubit.dart';
import '../../logic/app_cubit/app_state.dart';

class DarkLightSwitch extends StatelessWidget {
  const DarkLightSwitch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<AppCubit, AppState>(
        buildWhen: (previous, current) =>
            current is AppDarkState || current is AppLightState,
        builder: (context, state) {
          return Switch.adaptive(
            thumbIcon: const WidgetStatePropertyAll(
              Icon(Icons.dark_mode),
            ),
            value: getIt<AppCubit>().isDarkMode,
            onChanged: (value) {
              if (value) {
                getIt<AppCubit>().onDarkEvent();
              } else {
                getIt<AppCubit>().onLightEvent();
              }
            },
          );
        },
      ),
    );
  }
}
