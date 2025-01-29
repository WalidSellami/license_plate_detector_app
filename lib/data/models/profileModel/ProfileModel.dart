class ProfileModel {

  dynamic id;
  String? name;
  String? email;

  ProfileModel.fromJson(Map<String, dynamic> json) {

    id = json['user_id'];
    name = json['name'];
    email = json['email'];

  }


}