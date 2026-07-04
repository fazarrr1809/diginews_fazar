import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:diginews_fazar/data/datasources/news_local_data_source.dart';
import 'package:diginews_fazar/data/datasources/news_remote_data_source.dart';
import 'package:diginews_fazar/data/models/news_model.dart';

class NewsRepositoryImpl {
  final NewsRemoteDataSource remoteDataSource;
  final NewsLocalDataSource localDataSource;

  NewsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<List<NewsModel>> getNews() async {
    // 1. Cek status koneksi internet di HP Anda
    final connectivityResult = await Connectivity().checkConnectivity();
    
    // Jika ada koneksi internet (bukan none)
    if (!connectivityResult.contains(ConnectivityResult.none)) {
      try {
        // Ambil data terbaru dari API NewsAPI
        final remoteArticles = await remoteDataSource.fetchArticles();
        
        // Simpan (cache) data tersebut ke database Isar secara lokal
        await localDataSource.cacheNews(remoteArticles);
        
        // Urutkan Z ke A berdasarkan tantangan NIM Ganjil Anda
        remoteArticles.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        
        return remoteArticles;
      } catch (_) {
        // Jika API gagal merespons, otomatis fallback mengambil data dari cache Isar
        return _getSortedLocalData();
      }
    } else {
      // 2. TANTANGAN OFFLINE-FIRST: Jika HP masuk Airplane Mode (Koneksi None),
      // panggil data terakhir yang tersimpan di database Isar!
      return _getSortedLocalData();
    }
  }

  // Fungsi pembantu untuk mengambil data dari Isar dan mengurutkannya tetap Z ke A
  Future<List<NewsModel>> _getSortedLocalData() async {
    final localArticles = await localDataSource.getCachedNews();
    localArticles.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));
    return localArticles;
  }
}