import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _clickCount = 0;
  bool _showEasterEgg = false;

  // Integrasi Method Channel Native Android (Kotlin)
  static const platform = MethodChannel('com.fazar.diginews/nim');
  String _reversedNimResult = "";

  // Fungsi untuk memicu Method Channel ke kode Native Kotlin
  Future<void> _triggerNativeReverseNIM() async {
    try {
      // TANTANGAN ANTI-AI: Mengirim string NIM dari Dart ke Kotlin
      final String result = await platform.invokeMethod('reverseNIM', {'nim': '20123065'});
      setState(() {
        _reversedNimResult = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _reversedNimResult = "Gagal memanggil native: '${e.message}'.";
      });
    }
  }

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
                const SizedBox(height: 20),
                
                // Tombol Pemicu Native Integration (Method Channel)
                ElevatedButton(
                  onPressed: _triggerNativeReverseNIM,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[900],
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Picu Native Method Channel'),
                ),
                
                // Menampilkan hasil kembalian dari Kotlin di layar
                if (_reversedNimResult.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Hasil dari Kotlin: $_reversedNimResult',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ],
                
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