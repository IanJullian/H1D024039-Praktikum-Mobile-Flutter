import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  final Produk produk;

  const ProdukDetail({super.key, required this.produk});

  @override
  State<ProdukDetail> createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory_2, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                'Kode: ${widget.produk.kodeProduk ?? '-'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(
                'Nama: ${widget.produk.namaProduk ?? '-'}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 12),
              Text(
                'Harga: Rp ${widget.produk.hargaProduk}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              _tombolHapusEdit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: _isDeleting ? null : _editProduk,
          child: const Text('EDIT'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: _isDeleting ? null : _confirmHapus,
          child: _isDeleting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('DELETE'),
        ),
      ],
    );
  }

  Future<void> _editProduk() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ProdukForm(produk: widget.produk),
      ),
    );

    if (result == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _confirmHapus() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Yakin ingin menghapus data produk ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('BATAL'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('YA, HAPUS'),
          ),
        ],
      ),
    );

    if (konfirmasi != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      final id = widget.produk.id;

      if (id == null) {
        throw Exception('ID produk tidak ditemukan');
      }

      final berhasil = await ProdukBloc.deleteProduk(id: id);

      if (!berhasil) {
        throw Exception('Gagal menghapus produk');
      }

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      debugPrint('Gagal menghapus produk: $error');

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => const WarningDialog(
          description: 'Hapus produk gagal, silahkan coba lagi.',
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }
}
