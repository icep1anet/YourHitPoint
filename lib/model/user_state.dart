import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_state.freezed.dart';

@freezed
class UserDataState with _$UserDataState {
  const factory UserDataState({
    @Default("Pochi") String avatarName,
    @Default("hukurou") String avatarType,
    String? userName,
    String? userId,
    @Default(0) int experienceLevel,
    @Default(0) int experiencePoint,
    @Default("") String gender,
    @Default(0) int age,
    @Default([]) List friendDataList,
    @Default(0) int maxSleepDuration,
    @Default(0) int maxTotalDaySteps,
  }) = _UserDataState;
}