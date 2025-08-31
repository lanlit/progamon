import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progamon/controllers/team_controller.dart';
import 'package:progamon/player/member.dart';
import '../widgets/member_card.dart';

class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({super.key});

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  final _nameCtrl = TextEditingController();
  int? _editingIndex; // != null คือโหมดแก้ไข

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      _editingIndex = args['index'] as int?;
      final Team? t = args['team'] as Team?;
      if (t != null) {
        _nameCtrl.text = t.name;
        final c = Get.find<TeamController>();
        if (c.selected.isEmpty) {
          c.selected.addAll(t.members); // เติม selection ตอนเข้าหน้าแก้ไข
        }
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TeamController>();
    final isEditing = _editingIndex != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'แก้ไขทีม' : 'สร้างทีม'),
        actions: [
          Obx(() => c.selected.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'ล้างการเลือก',
                  onPressed: c.resetSelection,
                  icon: const Icon(Icons.clear_all),
                )),
        ],
      ),
      body: Column(
        children: [
          // ชื่อทีม + ตัวนับ
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameCtrl,
                    onChanged: (_) => setState(() {}), // ให้ปุ่มบันทึกรีเฟรชเมื่อชื่อเปลี่ยน
                    decoration: const InputDecoration(
                      labelText: 'ชื่อทีม',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Obx(() => Chip(
                      label: Text('เลือก: ${c.selected.length}/${TeamController.maxPick}'),
                    )),
              ],
            ),
          ),

          // ✅ แถบรูปสมาชิกที่เลือกไว้: อยู่กึ่งกลาง + เอาแต่ภาพ
          Obx(() {
            final items = c.selected.toList();
            if (items.isEmpty) {
              return const SizedBox(height: 12); // เว้นช่องเล็กน้อยตอนยังไม่เลือก
            }
            return SizedBox(
              height: 96,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: items.map((m) {
                    final a = m.avatar ?? '';
                    final isNet = a.startsWith('http');

                    Widget img;
                    if (isNet) {
                      img = ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: a,
                          width: 76,
                          height: 76,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (_, __, ___) => const CircleAvatar(
                            radius: 38,
                            child: Icon(Icons.image_not_supported),
                          ),
                        ),
                      );
                    } else {
                      // เผื่อกรณีเป็น asset
                      img = CircleAvatar(
                        radius: 38,
                        backgroundImage: a.isEmpty ? null : AssetImage(a),
                        child: a.isEmpty
                            ? const Icon(Icons.person_outline)
                            : null,
                      );
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              color: Colors.black.withOpacity(0.12),
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: img,
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }),

          // ช่องค้นหาสมาชิก (คนในลิสต์)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: c.filter,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'ค้นหาชื่อสมาชิก…',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // รายชื่อสมาชิก (แตะซ้ำเพื่อลบเครื่องหมายถูก)
          Expanded(
            child: Obx(() {
              final list = c.filtered;
              if (list.isEmpty) {
                return const Center(child: Text('ไม่พบสมาชิกที่ค้นหา'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: list.length,
                itemBuilder: (_, i) {
                  final m = list[i];
                  // ห่อ "แต่ละ tile" ด้วย Obx เพื่อให้รีเฟรชทันทีเมื่อ c.selected เปลี่ยน
                  return Obx(() {
                    final isSel = c.isSelected(m);
                    final full = c.selected.length >= TeamController.maxPick;
                    final enabled = isSel || !full; // ถ้าเต็มแล้ว กดได้เฉพาะที่ถูกเลือก
                    return Opacity(
                      opacity: enabled ? 1 : 0.5,
                      child: MemberCard(
                        key: ValueKey(m.id), // ช่วย diff ให้ถูกตัว
                        member: m,
                        selected: isSel,
                        onTap: enabled ? () => c.toggle(m) : null,
                      ),
                    );
                  });
                },
              );
            }),
          ),

          // ปุ่มล่าง: ล้างการเลือก + บันทึก/อัปเดต
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Obx(() {
                final canSave =
                    _nameCtrl.text.trim().isNotEmpty &&
                    c.selected.length == TeamController.maxPick;

                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: c.selected.isEmpty ? null : c.resetSelection,
                        icon: const Icon(Icons.refresh),
                        label: const Text('ล้างการเลือก'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: !canSave
                            ? null
                            : () {
                                final name = _nameCtrl.text.trim();
                                final newTeam = Team(
                                  name: name,
                                  members: c.selected.toList(),
                                );
                                if (isEditing) {
                                  c.updateTeamAt(_editingIndex!, newTeam);
                                  c.resetSelection();
                                  Get.back();
                                  Get.snackbar('อัปเดตแล้ว',
                                      'ทีม "$name" ถูกอัปเดตเรียบร้อย',
                                      snackPosition: SnackPosition.BOTTOM);
                                } else {
                                  c.saveTeam(name);
                                }
                              },
                        icon: Icon(isEditing ? Icons.save_as : Icons.check_circle),
                        label: Text(isEditing ? 'อัปเดตทีม' : 'บันทึกทีมเลยจ'),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
