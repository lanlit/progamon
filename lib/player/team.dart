import 'package:progamon/player/member.dart';

class Member {
  final int id;
  final String name;

  /// ใส่ได้ทั้งลิงก์ภาพ (http...) หรือพาธ assets เช่น assets/members/a.png
  final String? avatar;

  Member({required this.id, required this.name, this.avatar});

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'],
        name: json['name'],
        avatar: json['avatar'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar,
      };
}
