import 'dart:convert';

import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  // Mengambil seluruh data produk.
  static Future<List<Produk>> getProduks() async {
    final response = await Api().get(ApiUrl.listProduk);

    final jsonObj = json.decode(response.body) as Map<String, dynamic>;
    final List<dynamic> listProduk = jsonObj['data'];

    return listProduk
        .map((item) => Produk.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Menambahkan produk baru.
  static Future<bool> addProduk({required Produk produk}) async {
    final body = {
      'kode_produk': produk.kodeProduk,
      'nama_produk': produk.namaProduk,
      'harga': produk.hargaProduk.toString(),
    };

    final response = await Api().post(ApiUrl.createProduk, body);
    final jsonObj = json.decode(response.body) as Map<String, dynamic>;

    return jsonObj['status'] == true;
  }

  // Mengubah data produk.
  static Future<bool> updateProduk({required Produk produk}) async {
    final apiUrl = ApiUrl.updateProduk(produk.id!);

    final body = {
      'kode_produk': produk.kodeProduk,
      'nama_produk': produk.namaProduk,
      'harga': produk.hargaProduk.toString(),
    };

    final response = await Api().put(apiUrl, body);
    final jsonObj = json.decode(response.body) as Map<String, dynamic>;

    return jsonObj['status'] == true;
  }

  // Menghapus produk.
  static Future<bool> deleteProduk({required int id}) async {
    final apiUrl = ApiUrl.deleteProduk(id);

    final response = await Api().delete(apiUrl);
    final jsonObj = json.decode(response.body) as Map<String, dynamic>;

    return jsonObj['status'] == true;
  }
}
