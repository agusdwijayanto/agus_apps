import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../widgets/gambar_pengumuman.dart';
import 'detail_page.dart';
import 'form_pengumuman_page.dart';
import 'profile_page.dart';

class Dashboard extends StatefulWidget {
  final Map<String, dynamic>? user;

  const Dashboard({super.key, this.user});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  int _listVersion = 0;

  static const List<String> _titles = ['Beranda', 'Favorit', 'Profil'];

  Future<void> _tambahPengumuman() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormPengumumanPage()),
    );
    if (hasil == true) {
      setState(() => _listVersion++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _PengumumanTab(
        key: const ValueKey('beranda'),
        favoritOnly: false,
        version: _listVersion,
        namaUser: widget.user?['nama'] ?? 'Mahasiswa',
      ),
      _PengumumanTab(
        key: const ValueKey('favorit'),
        favoritOnly: true,
        version: _listVersion,
      ),
      ProfilPage(user: widget.user),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                'assets/images/logo.png',
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.school, size: 28);
                },
              ),
            ),
            const SizedBox(width: 8),
            Text('${_titles[_selectedIndex]} - Agus Apps'),
          ],
        ),
      ),
      body: pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 2
          ? null
          : FloatingActionButton(
              onPressed: _tambahPengumuman,
              child: const Icon(Icons.add),
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class _PengumumanTab extends StatefulWidget {
  final bool favoritOnly;
  final int version;
  final String? namaUser;

  const _PengumumanTab({
    super.key,
    required this.favoritOnly,
    required this.version,
    this.namaUser,
  });

  @override
  State<_PengumumanTab> createState() => _PengumumanTabState();
}

class _PengumumanTabState extends State<_PengumumanTab> {
  List<Map<String, dynamic>> _data = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  @override
  void didUpdateWidget(covariant _PengumumanTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.version != widget.version ||
        oldWidget.favoritOnly != widget.favoritOnly) {
      _muatData();
    }
  }

  Future<void> _muatData() async {
    final hasil = widget.favoritOnly
        ? await DatabaseHelper.instance.getFavoritPengumuman()
        : await DatabaseHelper.instance.getAllPengumuman();
    if (!mounted) return;
    setState(() {
      _data = hasil;
      _loading = false;
    });
  }

  Future<void> _bukaDetail(Map<String, dynamic> item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailPage(idPengumuman: item['id'] as int),
      ),
    );
    _muatData();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.favoritOnly)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Selamat datang, ${widget.namaUser}\nInformasi Akademik terbaru:',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        Expanded(
          child: _data.isEmpty
              ? const Center(child: Text('Belum ada data'))
              : ListView.builder(
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final item = _data[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GambarPengumuman(
                            path: item['gambar'] as String,
                            width: 56,
                            height: 56,
                          ),
                        ),
                        title: Text(
                          item['judul'] as String,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle:
                            Text('${item['kategori']} • ${item['tanggal']}'),
                        trailing: item['favorit'] == 1
                            ? const Icon(Icons.favorite, color: Colors.red)
                            : null,
                        onTap: () => _bukaDetail(item),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
