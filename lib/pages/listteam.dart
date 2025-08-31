import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progamon/player/member.dart';
import '../controllers/team_controller.dart';

class TeamListPage extends StatelessWidget {
  const TeamListPage({super.key});

  ImageProvider? _imageProvider(String? avatar) {
    if (avatar == null || avatar.isEmpty) return null;
    if (avatar.startsWith('http')) return NetworkImage(avatar);
    return AssetImage(avatar);
  }



  Widget _miniAvatar(Member m) {
    final provider = _imageProvider(m.avatar);
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: CircleAvatar(
        radius: 12,
        backgroundImage: provider,
        child: provider == null
            ? Text(
                m.name.characters.first.toUpperCase(),
                style: const TextStyle(fontSize: 12),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<TeamController>();
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        actions: [
          Obx(() => c.teams.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  tooltip: 'ลบทั้งหมด',
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('ยืนยันการลบ'),
                        content: const Text('ต้องการลบทีมทั้งหมดหรือไม่?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('ยกเลิก'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('ลบทั้งหมด'),
                          ),
                        ],
                      ),
                    );
                    if (ok == true) c.clearAllTeams();
                  },
                  icon: const Icon(Icons.delete_sweep_outlined),
                )),
        ],
      ),
      body: Obx(() {
        final teams = c.teams; // แตะ Rx ภายใน Obx
        if (teams.isEmpty) {
          // กล่องข้อความมีกรอบ + ไอคอน
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 520),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: cs.outlineVariant),
                  borderRadius: BorderRadius.circular(16),
                  color: cs.surfaceContainerLowest,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.groups_outlined, size: 48, color: cs.primary),
                    const SizedBox(height: 12),
                    Text(
                      'ยังไม่มีทีม',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'กดปุ่ม  +  มุมขวาล่างเพื่อสร้างทีมใหม่',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: teams.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) {
            final Team t = teams[i];
            final memberNames = t.members.map((m) => m.name).join(', ');
            final thumbs = t.members.take(3).toList();

            return Dismissible(
              key: ValueKey('${t.name}-$i'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.red.withOpacity(0.15),
                child: const Icon(Icons.delete_outline),
              ),
              confirmDismiss: (_) async {
                return await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('ลบทีมนี้?'),
                    content: Text('ต้องการลบทีม "${t.name}" หรือไม่'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('ยกเลิก'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('ลบ'),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (_) => c.deleteTeamAt(i),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  leading: CircleAvatar(
                    radius: 18,
                    child: Text('${t.members.length}'),
                  ),
                  title: Text(
                    t.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(memberNames, maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Row(children: thumbs.map(_miniAvatar).toList().cast<Widget>()),
                    ],
                  ),
                  trailing: IconButton(
                    tooltip: 'แก้ไขทีม',
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () {
                      // เตรียมข้อมูลเลือกเดิม + เปิดหน้าแก้ไข
                      c.selected
                        ..clear()
                        ..addAll(t.members);
                      Get.toNamed('/create', arguments: {
                        'index': i,
                        'team': t,
                      });
                    },
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          c.resetSelection();
          Get.toNamed('/create'); // โหมดสร้างใหม่
        },
        icon: const Icon(Icons.group_add),
        label: const Text('สร้างทีม'),
      ),
    );
  }
}
