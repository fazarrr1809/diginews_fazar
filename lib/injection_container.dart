import 'package:get_it/get_it.dart';
import 'package:diginews_fazar/core/network/dio_client.dart';
import 'package:diginews_fazar/data/datasources/news_remote_data_source.dart';
import 'package:diginews_fazar/data/repositories/news_repository_impl.dart';
import 'package:diginews_fazar/presentation/bloc/news_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC / Cubit (Gunakan factory karena state harus selalu di-reset saat pindah halaman)
  sl.registerFactory(() => NewsCubit(sl()));

  // Repositories (Sudah ada)
  sl.registerLazySingleton<NewsRepositoryImpl>(() => NewsRepositoryImpl(sl()));

  // Data Sources (Sudah ada)
  sl.registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSource(sl()));

  // Core (Sudah ada)
  sl.registerLazySingleton<DioClient>(() => DioClient());
}