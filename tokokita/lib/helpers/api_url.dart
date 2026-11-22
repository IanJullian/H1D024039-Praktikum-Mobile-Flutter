class ApiUrl {
  // Alamat backend CodeIgniter untuk Android Emulator.
  static const String baseUrl = 'http://127.0.0.1:8080';

  // Endpoint registrasi dan login.
  static const String registrasi = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';

  // Endpoint produk.
  static const String listProduk = '$baseUrl/produk';
  static const String createProduk = '$baseUrl/produk';

  // Backend menggunakan PUT /produk/{id} untuk update.
  static String updateProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  static String showProduk(int id) {
    return '$baseUrl/produk/$id';
  }

  static String deleteProduk(int id) {
    return '$baseUrl/produk/$id';
  }
}
