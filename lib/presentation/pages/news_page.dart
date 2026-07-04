import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diginews_fazar/injection_container.dart';
import 'package:diginews_fazar/presentation/bloc/news_cubit.dart';
import 'package:diginews_fazar/presentation/bloc/news_state.dart';
import 'package:diginews_fazar/presentation/pages/profile_page.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Memanggil NewsCubit dari Service Locator dan langsung mentrigger fetchNews()
      create: (_) => sl<NewsCubit>()..fetchNews(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DigiNews - Offline First'),
          backgroundColor: Colors.blueGrey[900],
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NewsSuccess) {
              final articles = state.articles;

              if (articles.isEmpty) {
                return const Center(child: Text('Tidak ada berita tersedia.'));
              }

              return ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final item = articles[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      leading: item.urlToImage.isNotEmpty
                          ? Image.network(
                              item.urlToImage,
                              width: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.broken_image, size: 50),
                            )
                          : const Icon(Icons.image, size: 50),
                      title: Text(
                        item.title, // Judul berita asli dari NewsAPI
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        item.description, // Deskripsi berita asli
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              );
            } else if (state is NewsError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              );
            }
            return const Center(child: Text('Memulai memuat data...'));
          },
        ),
      ),
    );
  }
}
