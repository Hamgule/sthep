class Exp {
  /// static variables
  static const register = 100.0;
  static const login = 10.0;
  static const createQuestion = 50.0;
  static const deleteQuestion = -50.0;
  static const createAnswer = 100.0;
  static const deleteAnswer = -100.0;
  static const adoptAnswer = 200.0;
  static const answerAdopted = 500.0;

  /// static methods
  static visualizeForm(double exp) => (exp < 0 ? '' : '+') + ' $exp EXP';

  /// variables
  double totalValue = 0.0;
  double value = 0.0;
  int level = 1;

  /// methods
  void _operate() {
    double _value = totalValue;
    int i = 1;

    while (_value >= quantity(i)) {
      _value -= quantity(i++);
    }

    value = _value;
    level = i;
  }
  void setExp(double totalValue) {
    this.totalValue = totalValue;
    _operate();
  }

  void gainExp(double add) {
    totalValue += add;
    if (totalValue < 0) totalValue = 0;
    _operate();
  }

  double accumQuantity(int n) {
    double _accum = 0.0;
    for (int i = 1; i < n; i++) {
      _accum += quantity(i);
    }
    return _accum;
  }

  double quantity(int n) => 10 + n * (n - 1) / 2;
  double get exp => value / quantity(level);

  String levelToString() => 'Lv. $level';
}