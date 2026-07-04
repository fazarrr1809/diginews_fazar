import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:diginews_fazar/core/network/dio_client.dart';
import 'package:diginews_fazar/data/datasources/news_collection.dart';
import 'package:diginews_fazar/data/datasources/news_local_data_source.dart';
import 'package:diginews_fazar/data/datasources/news_remote_data_source.dart';
import 'package:diginews_fazar/data/repositories/news_repository_impl.dart';
import 'package:diginews_fazar/presentation/bloc/news_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // 1. Inisialisasi Isar Database secara lokal di storage HP
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [NewsCollectionSchema], // Skema yang digenerate build_runner tadi
    directory: dir.path,
  );
  sl.registerSingleton<Isar>(isar);

  // BLoC / Cubit (Sudah ada)
  sl.registerFactory(() => NewsCubit(sl()));

  // Repositories (Perbarui agar menerima local data source nanti)
  sl.registerLazySingleton<NewsRepositoryImpl>(() => NewsRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ));

  // Data Sources
  sl.registerLazySingleton<NewsRemoteDataSource>(() => NewsRemoteDataSource(sl()));
  sl.registerLazySingleton<NewsLocalDataSource>(() => NewsLocalDataSource(sl()));

  // Core (Sudah ada)
  sl.registerLazySingleton<DioClient>(() => DioClient());
}