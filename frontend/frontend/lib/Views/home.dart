import 'package:flutter/material.dart';
import 'package:frontend/Core/ViewModel/left_bar_view_model.dart';
import 'package:frontend/Core/ViewModel/navigation_view_model.dart';
import 'package:frontend/CustomWidgets/custom_app_bar.dart';
import 'package:frontend/Views/navigation.dart';
import 'package:frontend/locator.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
