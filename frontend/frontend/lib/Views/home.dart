import 'package:flutter/material.dart';
import 'package:frontend/Core/Db/packet_table.dart';
import 'package:frontend/Core/ViewModel/left_bar_view_model.dart';
import 'package:frontend/Core/ViewModel/navigation_view_model.dart';
import 'package:frontend/CustomWidgets/custom_app_bar.dart';
import 'package:frontend/Views/navigation.dart';
import 'package:frontend/locator.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    locator.get<PacketTable>().deleteAll();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider<LeftBarViewModel>(
              create: (context) => locator.get<LeftBarViewModel>(),
            ),
            ChangeNotifierProvider<NavigationViewModel>(
              create: (context) => NavigationViewModel(),
            )
          ],
          child: const Navigation(),
        ),
      ),
    );
  }
}
