import 'package:get_it/get_it.dart';
import 'package:diginews_fazar/core/network/dio_client.dart';

final sl = GetIt.instance; // sl singkatan dari Service Locator

Future<void> init() async {
  // Daftarkan DioClient sebagai Singleton (hanya dibuat 1 kali selama aplikasi hidup)
  sl.registerLazySingleton<DioClient>(() => DioClient());
}