import 'package:diginews_fazar/core/network/dio_client.dart';
import 'package:diginews_fazar/data/models/news_model.dart';

class NewsRemoteDataSource {
  final DioClient _dioClient;

  NewsRemoteDataSource(this._dioClient);

  Future<List<NewsModel>> fetchArticles() async {
    try {
      final response = await _dioClient.dio.get(
        'everything', // Diubah dari top-headlines menjadi everything
        queryParameters: {
          'q': 'indonesia', // Mencari semua berita yang mengandung kata 'indonesia'
          'pageSize': 20,    // Mengambil 20 berita saja biar ringan
          'apiKey': '7600d484de0b4942a6b44a6b3ef7f7ad', // API Key resmi Fazar
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data['articles'] ?? [];
        return articlesJson.map((json) => NewsModel.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data berita resmi');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan jaringan: $e');
    }
  }
}