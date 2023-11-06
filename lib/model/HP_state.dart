import 'package:freezed_annotation/freezed_annotation.dart';
import "package:fl_chart/fl_chart.dart";
import 'package:flutter/material.dart';
import "package:logger/logger.dart";

part 'HP_state.freezed.dart';

var logger = Logger();

@freezed
class HPState with _$HPState {
  const factory HPState({
    @Default(Color.fromARGB(255, 0, 226, 113)) Color barColor,
    @Default(100) int currentHP,
    @Default(48.5) double fontPosition,
    @Default(Colors.white) Color fontColor,
    @Default([]) List<FlSpot> futureSpots,
    @Default(0) int hpNumber,
    @Default(100) int maxDayHP,
    @Default([]) List<FlSpot> pastSpots,
    double? minGraphX,
    double? maxGraphX,
    double? minGraphY,
    double? maxGraphY,
    @Default(0) double recordHighHP,
    @Default(0) double recordLowHP,
    String? imgUrl,
    DateTime? latestDataTime,
    @Default("") String activeLimitTime,
  }) = _HPState;
}

