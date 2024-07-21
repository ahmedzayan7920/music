import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../di/dependency_injection.dart';


class TimeSection extends StatelessWidget {
  const TimeSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final audioPlayer = getIt<AudioPlayer>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          StreamBuilder<Duration>(
            stream: audioPlayer.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              if (position.toString().split(".")[0][0] == "0") {
                return Text(position.toString().split(".")[0].substring(2));
              } else {
                return Text(position.toString().split(".")[0]);
              }
            },
          ),
          Expanded(
            child: StreamBuilder<Duration>(
              stream: audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                return Slider(
                  min: 0.0,
                  max: audioPlayer.duration?.inMicroseconds.toDouble() ?? 0.0,
                  value: audioPlayer.duration?.inMicroseconds.toDouble() == null
                      ? 0.0
                      : position.inMicroseconds.toDouble(),
                  onChanged: (double value) {
                    audioPlayer.seek(Duration(microseconds: value.toInt()));
                  },
                );
              },
            ),
          ),
          StreamBuilder<Duration?>(
            stream: audioPlayer.durationStream,
            builder: (context, snapshot) {
              final duration = snapshot.data ?? Duration.zero;
              if (duration.toString().split(".")[0][0] == "0") {
                return Text(duration.toString().split(".")[0].substring(2));
              } else {
                return Text(duration.toString().split(".")[0]);
              }
            },
          ),
        ],
      ),
    );
  }
}
