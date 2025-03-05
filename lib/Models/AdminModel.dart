class Admin {
  String uid;
  String firstName;
  String lastName;
  bool isAdmin;
  bool isDietitian;

  Admin({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.isAdmin,
    required this.isDietitian,
  });

  factory Admin.fromJson(Map<dynamic, dynamic> json) {
    return Admin(
      uid: json['uid'],
      isAdmin: json['isAdmin'],
      isDietitian: json['isDietitian'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'isAdmin':isAdmin,
      'isDietitan':isDietitian,
      'lastName': lastName,
    };
  }
}

