
class ColorRGB {

  ColorRGB(this.red, this.green, this.blue);

  /// 0-255
  final int red;
  /// 0-255
  final int green;
  /// 0-255
  final int blue;

  Map<String, int> toMap() {
    return {"red": red, "green": green, "blue": blue};
  }
}