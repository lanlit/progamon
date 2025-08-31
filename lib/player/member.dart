class Member {
  final int id;
  final String name;
  final String? avatar; // เก็บพาธรูป (asset หรือ URL)

  const Member({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json['id'] as int,
        name: json['name'] as String,
        avatar: json['avatar'] as String?, // อ่าน avatar จาก json
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatar': avatar, // เขียน avatar ลง json ด้วย
      };
}
