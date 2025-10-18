/// Utility class for generating mock data consistently across the app
///
/// This ensures that the same dog entity will have the same mock data
/// whether viewed on the home screen or details screen
class MockDataGenerator {
  /// Generates a consistent gender based on the dog's ID
  ///
  /// Using ID-based seeding ensures the same dog always gets the same gender
  static String randomGender(String id) {
    final seed = id.hashCode.abs() % 2;
    return ['Male', 'Female'][seed];
  }

  /// Generates a consistent age based on the dog's ID
  ///
  /// Using ID-based seeding ensures the same dog always gets the same age
  static String randomAge(String id) {
    final ages = [
      '3 Months Old',
      '1 Year',
      '2 Years',
      '5 Months Old',
    ];
    final seed = id.hashCode.abs() % ages.length;
    return ages[seed];
  }

  /// Generates a consistent distance based on the dog's ID
  ///
  /// Using ID-based seeding ensures the same dog always gets the same distance
  static String randomDistance(String id) {
    final distances = [
      '1.6 km away',
      '2.7 km away',
      '3 km away',
    ];
    final seed = id.hashCode.abs() % distances.length;
    return distances[seed];
  }
}
