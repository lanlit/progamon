import 'package:progamon/player/member.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TeamController extends GetxController {
  // ใช้รูปจาก URL: https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/XXX.png
  final allMembers = <Member>[
    Member(id: 1,  name: 'Bulbasaur',   avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/001.png'),
    Member(id: 2,  name: 'Bulbasaur',     avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/002.png'),
    Member(id: 3,  name: 'Venusaur',   avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/003.png'),
    Member(id: 4,  name: 'Chamander',   avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/004.png'),
    Member(id: 5,  name: 'Charmelon',     avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/005.png'),
    Member(id: 6,  name: 'Charizedrd',   avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/006.png'),
    Member(id: 7,  name: 'Squrized',   avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/007.png'),
    Member(id: 8,  name: 'Wartortle',   avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/008.png'),
    Member(id: 9,  name: 'Blastoise',    avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/009.png'),
    Member(id: 10, name: 'Metapod',    avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/010.png'),
    Member(id: 11, name: 'Mallory', avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/011.png'),
    Member(id: 12, name: 'Butterfree',    avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/012.png'),
    Member(id: 13, name: 'Weedle',  avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/013.png'),
    Member(id: 14, name: 'Kakuna',   avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/014.png'),
    Member(id: 15, name: 'Beedrill',   avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/015.png'),
    Member(id: 16, name: 'Pidgeotto',   avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/016.png'),
    Member(id: 17, name: 'Victor',  avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/017.png'),
    Member(id: 18, name: 'Pidgeot',  avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/018.png'),
    Member(id: 19, name: 'Rattata',  avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/019.png'),
    Member(id: 20, name: 'Raticate',  avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/020.png'),
    Member(id: 21, name: 'Spearow',    avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/021.png'),
    Member(id: 22, name: 'Fearow',    avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/022.png'),
    Member(id: 23, name: 'Ekans',   avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/023.png'),
    Member(id: 24, name: 'Arbok',    avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/024.png'),
    Member(id: 25, name: 'Pikachu',    avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/025.png'),
    Member(id: 26, name: 'Raichu',      avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/026.png'),
    Member(id: 27, name: 'Sandshrew',    avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/027.png'),
    Member(id: 28, name: 'Sandslas',    avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/028.png'),
    Member(id: 29, name: 'Nidoran',    avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/029.png'),
    Member(id: 30, name: 'Nidorina',    avatar: 'https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/030.png'),
  ].obs;

  final filtered = <Member>[].obs;
  final selected = <Member>[].obs;
  final teams = <Team>[].obs;

  static const int maxPick = 3;
  final _box = GetStorage();
  final _key = 'teams';

  @override
  void onInit() {
    super.onInit();
    filtered.assignAll(allMembers);
    _loadTeams();
  }

  void _loadTeams() {
    final raw = _box.read<List<dynamic>>(_key);
    if (raw != null) {
      final loaded =
          raw.map((e) => Team.fromJson(Map<String, dynamic>.from(e))).toList();
      teams.assignAll(loaded);
    }
  }

  void _persist() {
    _box.write(_key, teams.map((e) => e.toJson()).toList());
  }

  void resetSelection() => selected.clear();

  void toggle(Member m) {
    final already = selected.any((x) => x.id == m.id);
    if (already) {
      selected.removeWhere((x) => x.id == m.id);
      return;
    }
    if (selected.length >= maxPick) {
      Get.snackbar('เลือกครบแล้ว', 'เลือกได้สูงสุด $maxPick คนต่อทีม',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    selected.add(m);
  }

  bool isSelected(Member m) => selected.any((x) => x.id == m.id);

  void filter(String q) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) {
      filtered.assignAll(allMembers);
    } else {
      filtered.assignAll(
        allMembers.where((m) => m.name.toLowerCase().contains(query)).toList(),
      );
    }
  }

  bool canSave(String teamName) =>
      teamName.trim().isNotEmpty && selected.length == maxPick;

  void saveTeam(String teamName) {
    final name = teamName.trim();
    if (!canSave(name)) {
      Get.snackbar('ยังบันทึกไม่ได้', 'กรอกชื่อทีม และเลือกสมาชิกให้ครบ $maxPick คน',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    teams.add(Team(name: name, members: selected.toList()));
    _persist();
    resetSelection();
    Get.back();
    Get.snackbar('บันทึกแล้ว', 'ทีม "$name" ถูกบันทึกเรียบร้อย',
        snackPosition: SnackPosition.BOTTOM);
  }

  void deleteTeam(Team t) {
    teams.remove(t);
    _persist();
  }

  void deleteTeamAt(int index) {
    teams.removeAt(index);
    _persist();
  }

  void clearAllTeams() {
    teams.clear();
    _persist();
  }

  void updateTeamAt(int index, Team updated) {
    if (index < 0 || index >= teams.length) return;
    teams[index] = updated;
    _persist();
  }
}

// ============ Team model =============
class Team {
  final String name;
  final List<Member> members;

  Team({required this.name, required this.members});

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        name: json['name'],
        members: (json['members'] as List<dynamic>)
            .map((e) => Member.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'members': members.map((e) => e.toJson()).toList(),
      };
}
