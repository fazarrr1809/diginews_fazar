import 'package:diginews_fazar/data/datasources/news_remote_data_source.dart';
import 'package:diginews_fazar/data/models/news_model.dart';

class NewsRepositoryImpl {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl(this.remoteDataSource);

  Future<List<NewsModel>> getNews() async {
    // 1. Ambil data mentah dari API
    final articles = await remoteDataSource.fetchArticles();

    // 2. TANTANGAN ANTI-AI: Karena NIM Fazar berakhiran GANJIL (5), 
    // urutkan judul dari Z ke A (Descending) di layer Repository!
    articles.sort((a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()));

    return articles;
  }
}