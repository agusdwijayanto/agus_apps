import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = p.join(await getDatabasesPath(), 'akademik.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Tabel mahasiswa (data akun login & registrasi)
        await db.execute('''
          CREATE TABLE mahasiswa (
            nim TEXT PRIMARY KEY,
            nama TEXT NOT NULL,
            email TEXT NOT NULL,
            no_hp TEXT NOT NULL,
            jenis_kelamin TEXT NOT NULL,
            hobi TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
        // Tabel pengumuman (data utama Informasi Akademik)
        await db.execute('''
          CREATE TABLE pengumuman (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            kategori TEXT NOT NULL,
            tanggal TEXT NOT NULL,
            isi TEXT NOT NULL,
            gambar TEXT NOT NULL,
            favorit INTEGER NOT NULL DEFAULT 0
          )
        ''');
        await _seed(db);
      },
    );
  }

  Future<void> _seed(Database db) async {
    // User bawaan: NIM 241011750001 / password 241011750001
    await db.insert('mahasiswa', {
      'nim': '241011750001',
      'nama': 'Agus Dwijayanto',
      'email': 'agus@example.com',
      'no_hp': '-',
      'jenis_kelamin': 'Laki-laki',
      'hobi': '-',
      'password': '241011750001',
    });

    final List<Map<String, dynamic>> pengumumanAwal = [
      {
        'judul': 'Pendaftaran KRS Semester Genap 2026/2027',
        'kategori': 'Akademik',
        'tanggal': '12 Oktober 2026',
        'isi':
            'Pengisian Kartu Rencana Studi (KRS) semester genap dibuka mulai '
                'tanggal 19 Oktober sampai 30 Oktober 2026 melalui portal '
                'akademik. Mahasiswa wajib berkonsultasi dengan dosen '
                'pembimbing akademik sebelum mengunci KRS.',
        'gambar': 'assets/images/info_1.jpg',
        'favorit': 0,
      },
      {
        'judul': 'Jadwal Ujian Tengah Semester Ganjil 2026/2027',
        'kategori': 'Akademik',
        'tanggal': '14 Oktober 2026',
        'isi': 'Ujian Tengah Semester (UTS) semester ganjil dilaksanakan mulai '
            '21 Oktober 2026. Kartu ujian dapat diambil di bagian '
            'administrasi fakultas dengan syarat lunas pembayaran tahap '
            'pertama.',
        'gambar': 'assets/images/info_2.jpg',
        'favorit': 0,
      },
      {
        'judul': 'Pendaftaran Beasiswa Prestasi Mahasiswa 2026',
        'kategori': 'Beasiswa',
        'tanggal': '15 Oktober 2026',
        'isi': 'Dibuka pendaftaran beasiswa prestasi bagi mahasiswa aktif '
            'dengan IPK minimal 3,50. Berkas yang wajib dilampirkan: '
            'transkrip terakhir, sertifikat prestasi, dan surat '
            'rekomendasi dosen. Batas akhir pengumpulan 10 November 2026.',
        'gambar': 'assets/images/info_3.jpg',
        'favorit': 0,
      },
      {
        'judul': 'Pembayaran UKT Tahap Kedua Semester Ganjil',
        'kategori': 'Keuangan',
        'tanggal': '16 Oktober 2026',
        'isi': 'Pembayaran UKT tahap kedua dapat dilakukan melalui virtual '
            'account bank yang tertera pada portal mahasiswa. Batas '
            'akhir pembayaran tanggal 31 Oktober 2026. Keterlambatan '
            'dikenakan denda sesuai ketentuan universitas.',
        'gambar': 'assets/images/info_4.jpg',
        'favorit': 0,
      },
      {
        'judul': 'Seminar Nasional Teknologi Informasi 2026',
        'kategori': 'Kegiatan',
        'tanggal': '17 Oktober 2026',
        'isi': 'Program studi mengadakan seminar nasional bertema transformasi '
            'digital pada tanggal 7 November 2026 di aula kampus. '
            'Peserta mendapatkan e-sertifikat. Pendaftaran melalui '
            'sekretariat program studi, kuota terbatas 200 peserta.',
        'gambar': 'assets/images/info_5.jpg',
        'favorit': 0,
      },
      {
        'judul': 'Libur Nasional dan Cuti Bersama Bulan November',
        'kategori': 'Pengumuman',
        'tanggal': '18 Oktober 2026',
        'isi': 'Berdasarkan kalender akademik, kegiatan perkuliahan diliburkan '
            'pada tanggal 25 November 2026 dalam rangka hari libur '
            'nasional. Perkuliahan kembali berjalan normal pada hari '
            'berikutnya.',
        'gambar': 'assets/images/info_6.jpg',
        'favorit': 0,
      },
      {
        'judul': 'Pendaftaran Wisuda Periode November 2026',
        'kategori': 'Akademik',
        'tanggal': '19 Oktober 2026',
        'isi': 'Pendaftaran wisuda periode November 2026 dibuka bagi mahasiswa '
            'yang telah menyelesaikan sidang skripsi. Syarat: bebas '
            'tanggungan administrasi, keuangan, dan perpustakaan. Batas '
            'akhir pendaftaran tanggal 5 November 2026 di bagian '
            'administrasi fakultas.',
        'gambar': 'assets/images/info_1.jpg',
        'favorit': 0,
      },
      {
        'judul': 'Pengambilan Kartu Ujian Akhir Semester',
        'kategori': 'Akademik',
        'tanggal': '20 Oktober 2026',
        'isi': 'Kartu Ujian Akhir Semester (UAS) dapat diambil mulai tanggal '
            '27 Oktober 2026 di loket administrasi dengan membawa KTM '
            'dan bukti pembayaran UKT tahap kedua. Kartu ujian wajib '
            'dibawa selama ujian berlangsung.',
        'gambar': 'assets/images/info_2.jpg',
        'favorit': 0,
      },
      {
        'judul': 'Lomba Karya Tulis Ilmiah Mahasiswa 2026',
        'kategori': 'Kemahasiswaan',
        'tanggal': '21 Oktober 2026',
        'isi': 'BEM Fakultas mengadakan lomba karya tulis ilmiah bertema '
            'inovasi teknologi untuk pendidikan. Pendaftaran dibuka '
            'sampai 15 November 2026. Total hadiah jutaan rupiah dan '
            'e-sertifikat untuk seluruh peserta.',
        'gambar': 'assets/images/info_3.jpg',
        'favorit': 0,
      },
      {
        'judul': 'Rekrutmen Asisten Praktikum Semester Genap',
        'kategori': 'Kemahasiswaan',
        'tanggal': '22 Oktober 2026',
        'isi': 'Laboratorium komputer membuka rekrutmen asisten praktikum '
            'untuk semester genap 2026/2027. Syarat: mahasiswa aktif '
            'minimal semester 5 dengan nilai mata kuliah praktikum '
            'minimal B. Berkas lamaran dikirim ke laboratorium paling '
            'lambat 12 November 2026.',
        'gambar': 'assets/images/info_4.jpg',
        'favorit': 0,
      },
      {
        'judul': 'Workshop Penulisan Skripsi dan Publikasi Ilmiah',
        'kategori': 'Kegiatan',
        'tanggal': '23 Oktober 2026',
        'isi': 'Program studi mengadakan workshop penulisan skripsi dan '
            'publikasi ilmiah pada tanggal 14 November 2026. Workshop '
            'terbuka untuk mahasiswa semester 7 yang sedang menyusun '
            'skripsi. Pendaftaran melalui sekretariat program studi, '
            'kuota 100 peserta.',
        'gambar': 'assets/images/info_5.jpg',
        'favorit': 0,
      },
      {
        'judul': 'Pemeliharaan Sistem Portal Akademik',
        'kategori': 'Pengumuman',
        'tanggal': '24 Oktober 2026',
        'isi': 'Portal akademik akan menjalani pemeliharaan sistem pada '
            'tanggal 26 Oktober 2026 pukul 22.00 sampai 24.00 WIB. '
            'Selama masa pemeliharaan, portal tidak dapat diakses. '
            'Mahasiswa diharapkan menyelesaikan kebutuhan administrasi '
            'sebelum jadwal tersebut.',
        'gambar': 'assets/images/info_6.jpg',
        'favorit': 0,
      },
    ];

    for (final item in pengumumanAwal) {
      await db.insert('pengumuman', item);
    }
  }

  // ---------- Autentikasi ----------

  Future<Map<String, dynamic>?> login(String nim, String password) async {
    final db = await database;
    final result = await db.query(
      'mahasiswa',
      where: 'nim = ? AND password = ?',
      whereArgs: [nim, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> register(Map<String, dynamic> mahasiswa) async {
    final db = await database;
    return db.insert('mahasiswa', mahasiswa);
  }

  // ---------- Pengumuman (CRUD) ----------

  Future<List<Map<String, dynamic>>> getAllPengumuman() async {
    final db = await database;
    return db.query('pengumuman', orderBy: 'id DESC');
  }

  Future<List<Map<String, dynamic>>> getFavoritPengumuman() async {
    final db = await database;
    return db.query(
      'pengumuman',
      where: 'favorit = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
    );
  }

  Future<Map<String, dynamic>?> getPengumumanById(int id) async {
    final db = await database;
    final result = await db.query(
      'pengumuman',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertPengumuman(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert('pengumuman', data);
  }

  Future<int> updatePengumuman(Map<String, dynamic> data) async {
    final db = await database;
    return db.update(
      'pengumuman',
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  Future<int> deletePengumuman(int id) async {
    final db = await database;
    return db.delete('pengumuman', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> setFavorit(int id, bool favorit) async {
    final db = await database;
    return db.update(
      'pengumuman',
      {'favorit': favorit ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
