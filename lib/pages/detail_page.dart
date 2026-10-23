import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../widgets/gambar_pengumuman.dart';
import 'form_pengumuman_page.dart';

class DetailPage extends StatefulWidget {
  final int idPengumuman;

  const DetailPage({super.key, required this.idPengumuman});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? _item;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    final hasil =
        await DatabaseHelper.instance.getPengumumanById(widget.idPengumuman);
    if (!mounted) return;
    setState(() {
      _item = hasil;
      _loading = false;
    });
  }

  Future<void> _aksiFavorit() async {
    final item = _item;
    if (item == null) return;
    final sudahFavorit = item['favorit'] == 1;

    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text(sudahFavorit
            ? 'Yakin ingin menghapus dari favorit?'
            : 'Yakin ingin menambahkan ke favorit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    if (yakin != true) return;
    await DatabaseHelper.instance.setFavorit(item['id'] as int, !sudahFavorit);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(sudahFavorit
            ? 'Dihapus dari favorit'
            : 'Berhasil ditambahkan ke favorit'),
      ),
    );
    _muatData();
  }

  Future<void> _aksiHapus() async {
    final item = _item;
    if (item == null) return;

    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus pengumuman ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya'),
          ),
        ],
      ),
    );

    if (yakin != true) return;
    await DatabaseHelper.instance.deletePengumuman(item['id'] as int);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengumuman berhasil dihapus')),
    );
    Navigator.pop(context);
  }

  Future<void> _aksiEdit() async {
    final item = _item;
    if (item == null) return;
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FormPengumumanPage(data: item),
      ),
    );
    if (hasil == true) {
      _muatData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Pengumuman')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final item = _item;
    if (item == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Pengumuman')),
        body: const Center(child: Text('Data tidak ditemukan')),
      );
    }

    final sudahFavorit = item['favorit'] == 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pengumuman'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GambarPengumuman(
              path: item['gambar'] as String,
              width: double.infinity,
              height: 200,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['judul'] as String,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(label: Text(item['kategori'] as String)),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey.shade700),
                      const SizedBox(width: 4),
                      Text(item['tanggal'] as String),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item['isi'] as String,
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _aksiFavorit,
                      icon: Icon(sudahFavorit
                          ? Icons.favorite
                          : Icons.favorite_border),
                      label: Text(sudahFavorit
                          ? 'Hapus dari Favorit'
                          : 'Tambah ke Favorit'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _aksiEdit,
                          icon: const Icon(Icons.edit),
                          label: const Text('Edit'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _aksiHapus,
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text('Hapus',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
