// lib/utils.dart

String formatRupiah(double harga) {
  final formatted = harga.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  );
  return 'Rp $formatted';
}