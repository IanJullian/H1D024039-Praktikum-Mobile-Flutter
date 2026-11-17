import 'package:flutter/material.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukForm extends StatefulWidget {
  final Produk? produk;

  const ProdukForm({super.key, this.produk});

  @override
  State<ProdukForm> createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();

  bool get isUpdate => widget.produk != null;

  String get judul => isUpdate ? 'UBAH PRODUK' : 'TAMBAH PRODUK';

  String get tombolSubmit => isUpdate ? 'UBAH' : 'SIMPAN';

  @override
  void initState() {
    super.initState();

    if (isUpdate) {
      _kodeProdukTextboxController.text = widget.produk!.kodeProduk ?? '';
      _namaProdukTextboxController.text = widget.produk!.namaProduk ?? '';
      _hargaProdukTextboxController.text = widget.produk!.hargaProduk
          .toString();
    }
  }

  @override
  void dispose() {
    _kodeProdukTextboxController.dispose();
    _namaProdukTextboxController.dispose();
    _hargaProdukTextboxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                _namaProdukTextField(),
                _hargaProdukTextField(),
                const SizedBox(height: 24),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Textbox kode produk.
  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Kode Produk'),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Kode Produk harus diisi';
        }
        return null;
      },
    );
  }

  // Textbox nama produk.
  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Nama Produk'),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Nama Produk harus diisi';
        }
        return null;
      },
    );
  }

  // Textbox harga produk.
  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Harga'),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Harga harus diisi';
        }

        final harga = int.tryParse(value);

        if (harga == null || harga <= 0) {
          return 'Harga harus berupa angka lebih dari 0';
        }

        return null;
      },
    );
  }

  // Tombol simpan atau ubah.
  Widget _buttonSubmit() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _isLoading
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  _submit();
                }
              },
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(tombolSubmit),
      ),
    );
  }

  // Mengirim data produk ke REST API.
  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      final produk = Produk(id: widget.produk?.id);

      produk.kodeProduk = _kodeProdukTextboxController.text.trim();
      produk.namaProduk = _namaProdukTextboxController.text.trim();
      produk.hargaProduk = int.parse(_hargaProdukTextboxController.text.trim());

      final bool berhasil;

      if (isUpdate) {
        berhasil = await ProdukBloc.updateProduk(produk: produk);
      } else {
        berhasil = await ProdukBloc.addProduk(produk: produk);
      }

      if (!berhasil) {
        throw Exception('Permintaan produk gagal');
      }

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      debugPrint('Gagal menyimpan produk: $error');

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => WarningDialog(
          description: isUpdate
              ? 'Permintaan ubah data gagal, silahkan coba lagi.'
              : 'Simpan produk gagal, silahkan coba lagi.',
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
