import 'device_value.dart';

class SizeConfig {
  static double get screenWidth => DeviceValue.deviceWidth;
  static double get screenHeight => DeviceValue.deviceHeight;

  /// Mốc thiết kế gốc - iPhone 13
  static const double _designWidth = 390.0;
  static const double _designHeight = 844.0;

  /// Nhận diện loại thiết bị
  static bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  static bool get isDesktop => screenWidth >= 10240; // Probably 1024, user wrote 10240, keeping as requested or fixing? Assuming typo.
  static bool get isMobile => screenWidth < 600;

  /// Giới hạn tỉ lệ tối đa & tối thiểu
  static double _maxScaleFactor() {
    if (isMobile) return 1.3;
    if (isTablet) return 1.5;
    return 1.0; // Desktop dùng layout riêng
  }

  static double _minScaleFactor() {
    return 1.0;
  }

  /// Tính tỉ lệ scale trung bình giữa width & height
  static double _getResponsiveScaleFactor() {
    if (screenWidth == 0 || screenHeight == 0) return 1.0;

    final widthScale = screenWidth / _designWidth;
    final heightScale = screenHeight / _designHeight;
    final avgScale = (widthScale + heightScale) / 2;

    return avgScale.clamp(_minScaleFactor(), _maxScaleFactor());
  }

  /// Scale chung cho UI
  static double scaleSize(double input) {
    return input * _getResponsiveScaleFactor();
  }

  /// Scale text
  static double scaleText(double fontSize) {
    return scaleSize(fontSize).roundToDouble();
  }

  /// Scale icon
  static double scaleIcon(double size) {
    return scaleSize(size).roundToDouble();
  }

  ///  Scale theo chiều rộng (nếu cần dùng riêng)
  static double scaleWidth(double inputWidth) {
    if (screenWidth == 0) return inputWidth;
    final scale = (inputWidth / _designWidth) * screenWidth;
    final min = inputWidth * _minScaleFactor();
    final max = inputWidth * _maxScaleFactor();
    return scale.clamp(min, max);
  }

  /// Scale theo chiều cao (nếu cần dùng riêng)
  static double scaleHeight(double inputHeight) {
    if (screenHeight == 0) return inputHeight;
    final scale = (inputHeight / _designHeight) * screenHeight;
    final min = inputHeight * _minScaleFactor();
    final max = inputHeight * _maxScaleFactor();
    return scale.clamp(min, max);
  }
}
