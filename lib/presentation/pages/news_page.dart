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
    // Definisi palet warna gelap premium kustom (Deep Navy & Slate Dark)
    const backgroundColor = Color(0xFF0F172A); 
    const cardColor = Color(0xFF1E293B);

    return BlocProvider(
      create: (_) => sl<NewsCubit>()..fetchNews(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: const Text(
            'DigiNews Enterprise',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          backgroundColor: const Color(0xFF1E293B),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.account_circle_outlined, size: 28),
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
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            } else if (state is NewsSuccess) {
              final articles = state.articles;
              if (articles.isEmpty) {
                return const Center(
                  child: Text('Tidak ada berita tersedia.', style: TextStyle(color: Colors.white70)),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  final item = articles[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.urlToImage.isNotEmpty)
                            Image.network(
                              item.urlToImage,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 100,
                                color: Colors.blueGrey[800],
                                child: const Icon(Icons.broken_image, color: Colors.white30),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            key: ValueKey(item.title),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white70,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is NewsError) {
              return Center(
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              );
            }
            return const Center(child: Text('Memulai data...'));
          },
        ),
      ),
    );
  }
}