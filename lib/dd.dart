class P {
  late double x;
  late final double y;
  P(this.x, this.y);
  @override
  String toString() {
    return "( $x , $y)";
  }
}

void main() {
  P x = P(1, 3);
  print(x);
  x.x = 5;
  print(x);
}
