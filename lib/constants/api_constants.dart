class ApiConstants {
  static const String baseUrl = 'https://pixabay.com/api/';
  static const String apiKey = '46301885-274caf0025e3da76e354427fc';

  static String getImageUrl({required int page, int perPage = 20}) {
    return '$baseUrl?key=$apiKey&page=$page&per_page=$perPage';
  }
}
