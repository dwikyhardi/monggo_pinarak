class UserData {
  late String uid;
  late String name;
  late String email;
  late String userRole;
  // late String encryptedPassword;

  UserData(
      {required this.uid,
        required this.name,
      required this.email,
      required this.userRole,
      // required this.encryptedPassword
      });

  UserData.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    userRole = json['user_role'];
    // encryptedPassword = json['encrypted_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['user_role'] = this.userRole;
    // data['encrypted_password'] = this.encryptedPassword;
    return data;
  }
}
