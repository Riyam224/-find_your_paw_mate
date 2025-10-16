import 'package:dio/dio.dart';
import '../networking/api_constants.dart';

extension ReferenceImageExtension on String {
  /// Fetch actual Cat image URL using TheCatAPI
  Future<String?> fetchCatImageUrl(Dio dio) async {
    try {
      final response = await dio.get('images/$this');
      return response.data['url'] as String?;
    } catch (e) {
      print('🐾 Failed to fetch image for id: $this → $e');
      return null;
    }
  }

  /// Build CDN fallback URL
  String get cdnImageUrl => '${ApiPath.catImageCdn}$this.jpg';
}
