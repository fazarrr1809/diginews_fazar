import 'package:get_it/get_it.dart';
import 'package:diginews_fazar/core/network/dio_client.dart';
import 'package:diginews_fazar/data/datasources/news_remote_data_source.dart';
import 'package:diginews_fazar/data/repositories/news_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<NewsRepositoryImpl>(() => NewsRepositoryImpl(sl()));

  // Data Sources
  sl.registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSource(sl()));

  // Core (Sudah ada dari langkah sebelumnya)
  sl.registerLazySingleton<DioClient>(() => DioClient());
}