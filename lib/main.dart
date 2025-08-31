import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progamon/pages/create_team.dart';
import 'package:progamon/pages/listteam.dart';
// import 'controllers/team_controller.dart';
// import 'controllers/team_controller.dart'; // relative
import 'package:progamon/controllers/team_controller.dart';
import 'package:flutter/foundation.dart' as f;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // กันเคสที่มีการส่ง null เข้า debugPrint จากที่ไหนก็ได้
  final orig = f.debugPrint;
  f.debugPrint = (String? message, {int? wrapWidth}) {
    if (message == null) return;
    orig(message, wrapWidth: wrapWidth);
  };

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Team Builder (GetX)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(TeamController()); // inject controller
      }),
      getPages: [
        GetPage(name: '/', page: () => const TeamListPage()),
        GetPage(name: '/create', page: () => const CreateTeamPage()),
      ],
    );
  }
}
