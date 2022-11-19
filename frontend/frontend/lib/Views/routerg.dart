import 'package:flutter/material.dart';
import 'package:frontend/Core/ViewModel/custom_app_view_model.dart';
import 'package:frontend/Core/ViewModel/custom_app_view_model2.dart';
import 'package:frontend/Core/ViewModel/network_speed_viewmodel.dart';
import 'package:frontend/Dialog/dialog_manger.dart';
import 'package:frontend/Views/home.dart';
import 'package:frontend/locator.dart';
import 'package:provider/provider.dart';

class RouterG {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: ((context) => MultiProvider(
                providers: [
                  ChangeNotifierProvider<CustomAppViewModel>(
                    create: (context) => CustomAppViewModel(),
                  ),
                  ChangeNotifierProvider<CustomAppViewModel2>(
                    create: (context) => locator.get<CustomAppViewModel2>(),
                  ),
                  ChangeNotifierProvider<NetWorkSpeedViewModel>(
                    create: (context) => locator.get<NetWorkSpeedViewModel>(),
                  ),
                ],
                child: const DialogManager(child: Home()),
              )),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Text("No route defined for ${settings.name}")),
          ),
        );
    }
  }
}
