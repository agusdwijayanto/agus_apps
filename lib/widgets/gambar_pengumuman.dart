import 'dart:io';

import 'package:flutter/material.dart';

/// Menampilkan gambar pengumuman, dari asset lokal (assets/...)
/// maupun dari file galeri HP (path file).
class GambarPengumuman extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  const GambarPengumuman({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  Widget _error(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      width: width,
      height: height,
      color: Colors.blue.shade100,
      child: const Icon(Icons.campaign, color: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: _error,
      );
    }
    return Image.file(
      File(path),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: _error,
    );
  }
}
