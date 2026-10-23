import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../db/database_helper.dart';
import '../widgets/gambar_pengumuman.dart';

class FormPengumumanPage extends StatefulWidget {
  final Map<String, dynamic>? data;

  const FormPengumumanPage({super.key, this.data});

  @override
  State<FormPengumumanPage> createState() => _FormPengumumanPageState();
}

class _FormPengumumanPageState extends State<FormPengumumanPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController judulController;
  late final TextEditingController tanggalController;
  late final TextEditingController isiController;
  String kategori = 'Akademik';
  String gambar = '';

  final ImagePicker _picker = ImagePicker();

  static const List<String> daftarKategori = [
    'Akademik',
    'Beasiswa',
    'Kegiatan',
    'Keuangan',
    'Kemahasiswaan',
    'Pengumuman',
  ];

  static const List<String> namaBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  bool get _isEdit => widget.data != null;

  @override
  void initState() {
    super.initState();
    judulController = TextEditingController(text: widget.data?['judul'] ?? '');
    tanggalController =
        TextEditingController(text: widget.data?['tanggal'] ?? '');
    isiController = TextEditingController(text: widget.data?['isi'] ?? '');
    if (_isEdit) {
      kategori = widget.data!['kategori'] as String;
      gambar = widget.data!['gambar'] as String;
    }
  }

  @override
  void dispose() {
    judulController.dispose();
    tanggalController.dispose();
    isiController.dispose();
    super.dispose();
  }

  String _formatTanggal(DateTime tanggal) {
    return '${tanggal.day} ${namaBulan[tanggal.month - 1]} ${tanggal.year}';
  }

  DateTime _bacaTanggal(String teks) {
    try {
      final bagian = teks.split(' ');
      final hari = int.parse(bagian[0]);
      final bulan = namaBulan.indexOf(bagian[1]) + 1;
      final tahun = int.parse(bagian[2]);
      if (bulan < 1) return DateTime.now();
      return DateTime(tahun, bulan, hari);
    } catch (_) {
      return DateTime.now();
    }
  }

  Future<void> _pilihTanggal() async {
    final awal = tanggalController.text.isEmpty
        ? DateTime.now()
        : _bacaTanggal(tanggalController.text);
    final dipilih = await showDatePicker(
      context: context,
      initialDate: awal,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (dipilih != null) {
      setState(() {
        tanggalController.text = _formatTanggal(dipilih);
      });
    }
  }

  Future<void> _pilihGambar() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        gambar = file.path;
      });
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    if (gambar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih gambar dari galeri dulu')),
      );
      return;
    }

    final data = {
      'judul': judulController.text.trim(),
      'kategori': kategori,
      'tanggal': tanggalController.text.trim(),
      'isi': isiController.text.trim(),
      'gambar': gambar,
      'favorit': _isEdit ? widget.data!['favorit'] : 0,
    };

    if (_isEdit) {
      data['id'] = widget.data!['id'];
      await DatabaseHelper.instance.updatePengumuman(data);
    } else {
      await DatabaseHelper.instance.insertPengumuman(data);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEdit
            ? 'Pengumuman berhasil diubah'
            : 'Pengumuman berhasil ditambahkan'),
      ),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit Pengumuman' : 'Tambah Pengumuman'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: judulController,
              decoration: const InputDecoration(
                labelText: 'Judul Pengumuman',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: daftarKategori
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  kategori = value ?? 'Akademik';
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: tanggalController,
              readOnly: true,
              onTap: _pilihTanggal,
              decoration: const InputDecoration(
                labelText: 'Tanggal',
                hintText: 'Ketuk untuk memilih tanggal',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal wajib dipilih';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            if (gambar.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GambarPengumuman(
                  path: gambar,
                  width: double.infinity,
                  height: 160,
                ),
              )
            else
              Container(
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Belum ada gambar dipilih'),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _pilihGambar,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pilih dari Galeri'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: isiController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi Pengumuman',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Isi tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _simpan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('SIMPAN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
