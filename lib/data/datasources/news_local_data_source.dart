import 'package:isar/isar.dart';
import 'package:diginews_fazar/data/datasources/news_collection.dart';
import 'package:diginews_fazar/data/models/news_model.dart';

class NewsLocalDataSource {
  final Isar _isar;

  NewsLocalDataSource(this._isar);

  // 1. Fungsi untuk menyimpan data dari API ke dalam Isar (Caching)
  Future<void> cacheNews(List<NewsModel> articles) async {
    // Ubah Model ke bentuk Collection Isar
    final newsCollections = articles.map((article) {
      return NewsCollection()
        ..title = article.title
        ..description = article.description
        ..urlToImage = article.urlToImage;
    }).toList();

    // Tulis ke database lokal, hapus data lama dulu agar selalu fresh
    await _isar.writeTxn(() async {
      await _isar.newsCollections.clear();
      await _isar.newsCollections.putAll(newsCollections);
    });
  }

  // 2. Fungsi untuk mengambil data dari Isar saat offline (Airplane Mode)
  Future<List<NewsModel>> getCachedNews() async {
    final cachedData = await _isar.newsCollections.where().findAll();
    
    // Kembalikan ke bentuk NewsModel agar bisa dibaca oleh Repository & BLoC
    return cachedData.map((data) {
      return NewsModel(
        title: data.title,
        description: data.description,
        urlToImage: data.urlToImage,
      );
    }).toList();
  }
}