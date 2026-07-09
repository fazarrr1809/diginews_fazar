import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';

// Import komponen internal aplikasi
import 'package:diginews_fazar/core/network/dio_client.dart';
import 'package:diginews_fazar/data/datasources/news_remote_data_source.dart';
import 'package:diginews_fazar/data/models/news_model.dart';
import 'package:diginews_fazar/data/repositories/news_repository_impl.dart';
import 'package:diginews_fazar/presentation/bloc/news_cubit.dart';
import 'package:diginews_fazar/presentation/bloc/news_state.dart';

// Definisi Mock Class
class MockDio extends Mock implements Dio {}

class MockDioClient extends Mock implements DioClient {}

class MockNewsRepository extends Mock implements NewsRepositoryImpl {}

void main() {
  late MockDio mockDio;
  late MockDioClient mockDioClient;
  late NewsRemoteDataSource remoteDataSource;

  late MockNewsRepository mockNewsRepository;
  late NewsCubit newsCubit;

  final tArticlesJson = [
    {
      'title': 'Berita Indonesia A',
      'description': 'Deskripsi A',
      'urlToImage': 'https://image.com/a.png',
    },
    {
      'title': 'Berita Indonesia B',
      'description': 'Deskripsi B',
      'urlToImage': 'https://image.com/b.png',
    },
  ];

  final tNewsModels = [
    NewsModel(
      title: 'Berita Indonesia B',
      description: 'Deskripsi B',
      urlToImage: 'https://image.com/b.png',
    ),
    NewsModel(
      title: 'Berita Indonesia A',
      description: 'Deskripsi A',
      urlToImage: 'https://image.com/a.png',
    ),
  ];

  setUp(() {
    mockDio = MockDio();
    mockDioClient = MockDioClient();
    when(() => mockDioClient.dio).thenReturn(mockDio);
    remoteDataSource = NewsRemoteDataSource(mockDioClient);

    mockNewsRepository = MockNewsRepository();
    newsCubit = NewsCubit(mockNewsRepository);
  });

  tearDown(() {
    newsCubit.close();
  });

  group('Diginews Fazar - Unit Testing (Native Flutter Test)', () {
    // TEST 1: Menguji NewsRemoteDataSource
    test(
      '1. fetchArticles mengembalikan List<NewsModel> saat HTTP 200',
      () async {
        when(
          () => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: {'articles': tArticlesJson},
            statusCode: 200,
            requestOptions: RequestOptions(path: 'everything'),
          ),
        );

        final result = await remoteDataSource.fetchArticles();

        expect(result, isA<List<NewsModel>>());
        expect(result.length, 2);
        verify(
          () => mockDio.get(
            'everything',
            queryParameters: any(named: 'queryParameters'),
          ),
        ).called(1);
      },
    );

    // TEST 2: Menguji NewsCubit Sukses menggunakan expectLater bawaan Flutter
    test(
      '2. Memancarkan [NewsLoading, NewsSuccess] ketika fetchNews() berhasil',
      () async {
        // Arrange
        when(
          () => mockNewsRepository.getNews(),
        ).thenAnswer((_) async => tNewsModels);

        // Assert - Pantau stream state sebelum fungsi dipanggil
        final expectedStates = [
          isA<NewsLoading>(),
          isA<NewsSuccess>().having(
            (state) => state.articles.length,
            'jumlah artikel',
            2,
          ),
        ];
        expectLater(newsCubit.stream, emitsInOrder(expectedStates));

        // Act - Jalankan fungsi
        await newsCubit.fetchNews();
      },
    );

    // TEST 3: Menguji NewsCubit Error menggunakan expectLater bawaan Flutter
    test(
      '3. Memancarkan [NewsLoading, NewsError] ketika repository gagal',
      () async {
        // Arrange
        when(
          () => mockNewsRepository.getNews(),
        ).thenThrow(Exception('Gagal mengambil data berita resmi'));

        // Assert
        final expectedStates = [
          isA<NewsLoading>(),
          isA<NewsError>().having(
            (state) => state.message,
            'pesan error',
            contains('Gagal mengambil data berita resmi'),
          ),
        ];
        expectLater(newsCubit.stream, emitsInOrder(expectedStates));

        // Act
        await newsCubit.fetchNews();
      },
    );
  });
}
