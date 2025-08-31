import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:progamon/player/member.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  final bool selected;
  final VoidCallback? onTap;

  const MemberCard({
    super.key,
    required this.member,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final a = member.avatar ?? '';
    final isNet = a.startsWith('http');

    Widget pic;
    if (a.isEmpty) {
      pic = CircleAvatar(
        radius: 32,
        child: Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?'),
      );
    } else if (isNet) {
      pic = CircleAvatar(
        radius: 32,
        backgroundColor: Colors.grey.shade200,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: a,
            width: 64, height: 64, fit: BoxFit.cover,
            placeholder: (_, __) => const SizedBox(
              width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            errorWidget: (_, __, ___) => Center(
              child: Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?'),
            ),
          ),
        ),
      );
    } else {
      pic = CircleAvatar(radius: 32, backgroundImage: AssetImage(a));
    }

    return Material(
      borderRadius: BorderRadius.circular(16),
      elevation: selected ? 6 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  pic,
                  if (selected)
                    const Positioned(
                      right: -2, bottom: -2,
                      child: Icon(Icons.check_circle, size: 22),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                member.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
