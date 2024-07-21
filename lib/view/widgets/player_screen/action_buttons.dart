import 'package:flutter/material.dart';

import 'next_button.dart';
import 'play_pause_button.dart';
import 'previous_button.dart';
import 'repeat_button.dart';
import 'shuffle_button.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ShuffleButton(),
        PreviousButton(),
        PlayPauseButton(),
        NextButton(),
        RepeatButton(),
      ],
    );
  }
}
