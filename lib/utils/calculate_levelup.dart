double calculateLevelUp(int experienceLevel, int experiencePoint) {
  int point = 0;
  for (int i = 0; i < experienceLevel; i++) {
    point = 500 * (1 + i ~/ 5);
    experiencePoint = experiencePoint - point;
  }
  int levelUpPoint = 500 * (1 + experienceLevel ~/ 5);
  double levelUpRate = ((experiencePoint / levelUpPoint) * 360);
  return levelUpRate;
}