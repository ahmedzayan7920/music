import 'package:flutter/material.dart';

@immutable
sealed class AppState {}

final class AppInitialState extends AppState {}

final class AppDarkState extends AppState {}

final class AppLightState extends AppState {}


