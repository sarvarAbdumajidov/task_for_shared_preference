class Account {
  String? fullName;
  String? email;
  String? phone;
  String? password;

  Account(this.fullName, this.email, this.phone, this.password);

  Account.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password
      };
}
