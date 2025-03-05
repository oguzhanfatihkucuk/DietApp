class Dietitian {
  String uid;
  String firstName;
  String lastName;
  String email;
  String phone;
  int age;
  String gender;
  bool isAdmin;
  bool isDietitian;

  Dietitian({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.isAdmin,
    required this.isDietitian,
    required this.age,
    required this.gender,
  });

  factory Dietitian.fromJson(Map<dynamic, dynamic> json) {
    return Dietitian(
      uid: json['uid'],
      isAdmin: json['isAdmin'],
      isDietitian: json['isDietitian'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      age: json['age'],
      gender: json['gender'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'isAdmin':isAdmin,
      'isDietitan':isDietitian,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
    };
  }
}

