class Exp {
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