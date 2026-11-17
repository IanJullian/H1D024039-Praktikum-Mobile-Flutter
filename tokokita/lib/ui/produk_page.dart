import 'package:flutter/material.dart';
import 'package:tokokita/bloc/logout_bloc.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  late Future<List<Produk>> _produkFuture;

  @override
  void initState() {
    super.initState();
    _produkFuture = ProdukBloc.getProduks();
  }

  void _refreshProduk() {
    setState(() {
      _produkFuture = ProdukBloc.getProduks();
    });
  }

  Future<void> _tambahProduk() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProdukForm()),
    );

    if (!mounted) return;
    _refreshProduk();
  }

  Future<void> _logout() async {
    await LogoutBloc.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _tambahProduk),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshProduk,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text(
                  'TOKO KITA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              trailing: const Icon(Icons.logout),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Produk>>(
        future: _produkFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gagal mengambil data produk'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _refreshProduk,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          final produks = snapshot.data ?? [];

          if (produks.isEmpty) {
            return const Center(child: Text('Belum ada data produk'));
          }

          return ListProduk(list: produks, onChanged: _refreshProduk);
        },
      ),
    );
  }
}

class ListProduk extends StatelessWidget {
  final List<Produk> list;
  final VoidCallback onChanged;

  const ListProduk({super.key, required this.list, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, i) {
        return ItemProduk(produk: list[i], onChanged: onChanged);
      },
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;
  final VoidCallback onChanged;

  const ItemProduk({super.key, required this.produk, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (context) => ProdukDetail(produk: produk)),
        );

        if (result == true) {
          onChanged();
        }
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          leading: const Icon(Icons.inventory_2, color: Colors.blue),
          title: Text(produk.namaProduk ?? ''),
          subtitle: Text('Kode: ${produk.kodeProduk ?? '-'}'),
          trailing: Text(
            'Rp ${produk.hargaProduk}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
