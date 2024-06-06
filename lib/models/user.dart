class FirebaseUser{
  String? uid;
  String? name;
  String? email;
  String? password;
  String? img;

  FirebaseUser(this.uid, this.name, this.email, this.password, this.img);

  Map<String, dynamic> toJson(){
    return {
      'uid':uid,
      'name':name,
      'email':email,
      'password':password,
      'img':img
    };
  }

  FirebaseUser.fromJson(Map<String, dynamic>map){
    uid = map['uid'];
    name = map['name'];
    email = map['email'];
    password = map['password'];
    img = map['img'];
  }

}