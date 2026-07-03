import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diginews_fazar/data/repositories/news_repository_impl.dart';
import 'package:diginews_fazar/presentation/bloc/news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepositoryImpl _newsRepository;

  NewsCubit(this._newsRepository) : super(NewsInitial());

  Future<void> fetchNews() async {
    // Ubah state ke loading terlebih dahulu
    emit(NewsLoading());

    try {
      // Ambil data yang sudah otomatis terurut Z-A dari repository impl kita
      final articles = await _newsRepository.getNews();
      
      // Jika berhasil, kirim data ke UI lewat NewsSuccess
      emit(NewsSuccess(articles));
    } catch (e) {
      // Jika gagal, kirim pesan error lewat NewsError
      emit(NewsError(e.toString()));
    }
  }
}