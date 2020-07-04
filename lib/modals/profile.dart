// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
    Profile({
        this.data,
    });

    Data data;

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "data": data.toJson(),
    };
}

class Data {
    Data({
        this.name,
        this.email,
        this.phone,
        this.profilePicture,
        this.licencenumber,
    });

    String name;
    String email;
    String phone;
    String profilePicture;
    String licencenumber;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        profilePicture: json["profile_picture"],
        licencenumber: json["licencenumber"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "profile_picture": profilePicture,
        "licencenumber": licencenumber,
    };
}
