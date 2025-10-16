class ApiConstants {
  static const String baseUrl = 'https://api.thedogapi.com/v1/';
  static const String catApiBaseUrl = 'https://api.thecatapi.com/v1/';

  static const String apiKey =
      'live_7cq0hCbE5fULHwQIQ83GJ46H5onXUD2fWwgBcP76OuZNHDi1GWANHVhBJ8fawgIb';
}

class ApiPath {
  // Images endpoints
  static const String imagesSearch = 'images/search';
  static const String imageById = 'images/';

  // Breeds endpoints
  static const String breeds = 'breeds';
  static const String breedById = 'breeds/';
  static const String breedsSearch = 'breeds/search';

  // Favorites endpoints
  static const String favourites = 'favourites';
  static const String favouriteById = 'favourites/';

  // Votes endpoints
  static const String votes = 'votes';

  // Categories endpoint
  static const String categories = 'categories';

  // CDN URLs
  static const String dogImageCdn = 'https://cdn2.thedogapi.com/images/';
  static const String catImageCdn = 'https://cdn2.thecatapi.com/images/';
}

