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

  static const platform = MethodChannel('com.fazar.diginews/nim');
  String _reversedNimResult = "";

  Future<void> _triggerNativeReverseNIM() async {
    try {
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

    if (_clickCount == 5) {
      setState(() {
        _showEasterEgg = true;
        _clickCount = 0;
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showEasterEgg = false;
          });
        }
      });
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _clickCount < 5) {
        _clickCount = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF0F172A);
    const cardColor = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Developer & Academic Profile'),
        backgroundColor: cardColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Bagian Foto Profil dengan Efek Border Bersinar
                Center(
                  child: GestureDetector(
                    onTap: _handleProfileClick,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.blueGrey,
                        // Dipersiapkan untuk memuat foto lokal Fazar di folder assets
                        backgroundImage: AssetImage('assets/fazar_profile.jpeg'),
                        // Jika foto belum dimasukkan, ikon default ini akan menutupinya di latar belakang
                        child: Icon(Icons.person, size: 60, color: Colors.transparent), 
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Fazar Rizwanul Ikhlas',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text(
                  'NPM: 20123065',
                  style: TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ketukan Foto: $_clickCount / 5',
                  style: const TextStyle(fontSize: 12, color: Colors.white38),
                ),
                const SizedBox(height: 24),

                // Kartu Identitas Kampus & Mata Kuliah
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'INSTITUSI AKADEMIK',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1.0),
                      ),
                      Divider(color: Colors.white10, height: 16),
                      _ProfileInfoRow(label: 'Universitas', value: 'Universitas Teknologi Digital'),
                      _ProfileInfoRow(label: 'Mata Kuliah', value: 'Mobile Programming Lanjut'),
                      _ProfileInfoRow(label: 'Dosen Pengajar', value: 'Ir. Mamok Andri Senubekti, S.Kom., M.Kom.'),
                      _ProfileInfoRow(label: 'Semester', value: 'Genap (TA: 2025/2026)'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Area Tombol Aksi Method Channel Native
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'NATIVE INTEGRATION HARDWARE',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white38, letterSpacing: 1.0),
                      ),
                      const Divider(color: Colors.white10, height: 16),
                      ElevatedButton.icon(
                          onPressed: _triggerNativeReverseNIM,
                          icon: const Icon(Icons.integration_instructions_outlined, color: Colors.white),
                          label: const Text('Picu Kotlin Method Channel'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      if (_reversedNimResult.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check_circle_outline, color: Colors.blueAccent, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Kotlin Output: $_reversedNimResult',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          if (_showEasterEgg)
            Container(
              color: Colors.black.withValues(alpha: 0.85),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Lottie.asset('assets/easter_egg.json', fit: BoxFit.contain),
              ),
            ),
        ],
      ),
    );
  }
}

// Widget Pembantu untuk Baris Informasi Berpasangan
class _ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}