import 'package:diginews_fazar/core/network/dio_client.dart';
import 'package:diginews_fazar/data/models/news_model.dart';

class NewsRemoteDataSource {
  final DioClient _dioClient;

  NewsRemoteDataSource(this._dioClient);

  Future<List<NewsModel>> fetchArticles() async {
    try {
      // Kita gunakan endpoint top-headlines dari NewsAPI dengan API Key dummy/publik
      final response = await _dioClient.dio.get(
        'top-headlines',
        queryParameters: {
          'country': 'id',
          'apiKey': '9be69399478a48ff8a9df6be0702df91', // Contoh API Key publik sementara
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data['articles'] ?? [];
        return articlesJson.map((json) => NewsModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data berita');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}