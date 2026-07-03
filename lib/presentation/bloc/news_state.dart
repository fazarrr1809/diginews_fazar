import 'package:diginews_fazar/data/models/news_model.dart';

abstract class NewsState {}

// 1. State awal saat layar pertama kali dibuka
class NewsInitial extends NewsState {}

// 2. State saat aplikasi sedang menembak API (memunculkan indikator loading)
class NewsLoading extends NewsState {}

// 3. State saat data berita berhasil diambil dan diurutkan sesuai NIM
class NewsSuccess extends NewsState {
  final List<NewsModel> articles;
  NewsSuccess(this.articles);
}

// 4. State jika terjadi error/gagal koneksi
class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
}