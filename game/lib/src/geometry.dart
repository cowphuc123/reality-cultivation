/// Vị trí hai chiều và khoảng cách bằng số nguyên.
///
/// Trước V2.10 mọi thứ nằm trên một trục: vị trí là một số mm duy nhất. Yêu
/// cầu chọn nơi trên bản đồ rồi sinh ra ở đó cần hai chiều, nên trục thứ hai
/// được thêm dưới dạng **tùy chọn**: chỗ nào không khai báo `y` thì coi như
/// `y = 0`, và khoảng cách rút về đúng giá trị một chiều cũ.
class WorldPoint {
  const WorldPoint(this.xMm, [this.yMm = 0]);

  final int xMm;
  final int yMm;

  bool get onAxis => yMm == 0;

  /// Khoảng cách tới điểm khác, làm tròn xuống, tính bằng mm.
  ///
  /// Khi cả hai điểm đều nằm trên trục thì kết quả bằng đúng `|dx|`, nên các
  /// thế giới một chiều cũ không đổi kết quả.
  int distanceTo(WorldPoint other) {
    final int dx = other.xMm - xMm;
    final int dy = other.yMm - yMm;
    if (dy == 0) return dx.abs();
    if (dx == 0) return dy.abs();
    return integerSquareRoot(dx * dx + dy * dy);
  }

  @override
  String toString() => onAxis ? '$xMm' : '($xMm, $yMm)';
}

/// Căn bậc hai lấy phần nguyên, không dùng số thực để lượt chạy tái hiện được.
///
/// Với số chính phương thì trả về đúng căn, nên `isqrt(dx * dx) == |dx|`.
int integerSquareRoot(int value) {
  if (value < 0) throw ArgumentError.value(value, 'value', 'phải không âm');
  if (value < 2) return value;
  int low = 0;
  int high = value < 4 ? value : (value >> 1) + 1;
  while (low < high) {
    final int mid = low + (high - low + 1) ~/ 2;
    if (mid <= value ~/ mid) {
      low = mid;
    } else {
      high = mid - 1;
    }
  }
  return low;
}
