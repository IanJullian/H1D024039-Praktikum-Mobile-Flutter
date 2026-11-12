class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.code, this.status, this.token, this.userID, this.userEmail});

  factory Login.fromJson(Map<String, dynamic> obj) {
    final data = obj['data'];
    final user = data['user'];

    return Login(
      code: obj['code'],
      status: obj['status'],
      token: data['token'],
      userID: int.tryParse(user['id'].toString()),
      userEmail: user['email'],
    );
  }
}
