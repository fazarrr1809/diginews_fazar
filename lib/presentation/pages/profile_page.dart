import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _clickCount = 0;
  bool _showEasterEgg = false;

  void _handleProfileClick() {
    setState(() {
      _clickCount++;
    });

    // TANTANGAN ANTI-AI: Jika diklik tepat 5 kali (sesuai digit terakhir NIM 20123065)
    if (_clickCount == 5) {
      setState(() {
        _showEasterEgg = true;
        _clickCount = 0; // Reset counter
      });

      // Sembunyikan kembali animasi setelah 3 detik sesuai perintah soal
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showEasterEgg = false;
          });
        }
      });
    }

    // Reset hitungan jika user terlalu lama menjeda ketukan (misal lebih dari 2 detik)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _clickCount < 5) {
        _clickCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Profile'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Stack(
        children: [
          // Tampilan Utama Profil Anda
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _handleProfileClick, // Deteksi ketukan di foto
                  child: const CircleAvatar(
                    radius: 75,
                    backgroundColor: Colors.blueGrey,
                    child: Icon(Icons.person, size: 80, color: Colors.white), 
                    // Nanti Anda bisa menggantinya dengan AssetImage foto asli Anda
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Fazar Rizwanul Ikhlas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'NIM: 20123065',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Text('Ketukan Foto: $_clickCount / 5 (Ketuk cepat untuk kejutan!)'),
              ],
            ),
          ),

          // TANTANGAN ANTI-AI: Animasi Lottie memenuhi layar selama 3 detik
          if (_showEasterEgg)
            Container(
              color: Colors.black.withValues(alpha: 0.8), // Latar belakang gelap dramatis
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Lottie.asset(
                  'assets/easter_egg.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}