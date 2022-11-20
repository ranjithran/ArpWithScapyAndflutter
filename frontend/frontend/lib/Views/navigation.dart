import 'package:flutter/material.dart';
import 'package:frontend/Core/Services/api_service.dart';
import 'package:frontend/Core/ViewModel/attack_view_model.dart';
import 'package:frontend/Core/ViewModel/dashboardtwoviewmodel.dart';
import 'package:frontend/Core/ViewModel/left_bar_view_model.dart';
import 'package:frontend/Core/ViewModel/dashboardviewmodel.dart';
import 'package:frontend/Views/attack_window.dart';
import 'package:frontend/Views/dashboard2.dart';
import 'package:frontend/Views/hostsview.dart';
import 'package:frontend/Views/interfaceview.dart';
import 'package:frontend/Views/packetlistview.dart';
import 'package:frontend/locator.dart';
import 'package:provider/provider.dart';
import 'package:side_navigation/side_navigation.dart';
import 'package:tabler_icons/tabler_icons.dart';

import 'dashboard.dart';

class Navigation extends StatelessWidget {
  const Navigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LeftBarViewModel>(
      builder: (context, _, child) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SideNavigationBar(
            selectedIndex: _.selectedIndex,
            items: const [
              SideNavigationBarItem(
                icon: TablerIcons.network,
                label: 'Attack',
              ),
              SideNavigationBarItem(
                icon: Icons.computer_rounded,
                label: 'Victims',
              ),
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'DashBoard',
              ),
              SideNavigationBarItem(
                icon: Icons.dashboard,
                label: 'DashBoard2',
              ),
              SideNavigationBarItem(
                icon: TablerIcons.network,
                label: 'Top Traffice Hosts',
              ),
              SideNavigationBarItem(
                icon: TablerIcons.list,
                label: 'Captured Packet ',
              ),
            ],
            onTap: (index) {
              _.selectedIndex = index;
            },
            // Change the background color and disabled header/footer dividers
            // Make use of standard() constructor for other themes
            theme: SideNavigationBarTheme(
              backgroundColor: ThemeData.dark().drawerTheme.backgroundColor,
              togglerTheme: SideNavigationBarTogglerTheme.standard(),
              itemTheme: SideNavigationBarItemTheme(
                  selectedItemColor: Colors.purpleAccent,
                  selectedBackgroundColor: ThemeData.dark().dividerColor),
              dividerTheme: const SideNavigationBarDividerTheme(
                  mainDividerColor: Colors.purpleAccent,
                  showFooterDivider: false,
                  showHeaderDivider: false,
                  showMainDivider: true),
            ),
          ),
          Expanded(
            child: _getWidget(_.selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _getWidget(int index) {
    switch (index) {
      case 0:
        if (locator.isRegistered<AttackViewModel>()) {
          locator.resetLazySingleton<AttackViewModel>();
        }
        return MultiProvider(providers: [
          FutureProvider<List<IpWithMac>>(
            create: (context) => locator.get<AttackViewModel>().getListOfIpWithMax(),
            initialData: const [],
            lazy: false,
          ),
          ChangeNotifierProxyProvider<List<IpWithMac>, AttackViewModel>(
            update: (context, value, previous) {
              AttackViewModel attack = locator.get<AttackViewModel>();
              attack.ipvals = value;
              if (value.isNotEmpty) {
                attack.src = value[0];
                attack.dst = attack.src;
              }
              return attack;
            },
            create: (context) => locator.get<AttackViewModel>(),
            lazy: false,
          ),
        ], builder: (context, child) => const AttackWindow());

      case 1:
        return const HostView();
      case 2:
        if (locator.isRegistered<DashBoardViewModel>()) {
          locator.resetLazySingleton<DashBoardViewModel>();
        }
        return MultiProvider(providers: [
          FutureProvider<Map<String, double>>(
              create: (context) => locator.get<ApiService>().getMyLoc(),
              initialData: {},
              lazy: false),
          ChangeNotifierProxyProvider<Map<String, double>, DashBoardViewModel>(
            update: (context, value, previous) {
              DashBoardViewModel dashboard = locator.get<DashBoardViewModel>();
              dashboard.mylat = value;
              return dashboard;
            },
            create: (context) => locator.get<DashBoardViewModel>(),
          ),
        ], child: const DashBoard());
      case 3:
        if (locator.isRegistered<DashBoardTwoViewModel>()) {
          locator.resetLazySingleton<DashBoardTwoViewModel>();
        }
        return MultiProvider(providers: [
          ChangeNotifierProvider<DashBoardTwoViewModel>(
            create: (context) => locator.get<DashBoardTwoViewModel>(),
          )
        ], child: const DashBoard2());
      case 4:
        return const TopTrafficView();
      case 5:
        return PacketListView();
      default:
        return const Center(child: Text("Unable to find view"));
    }
  }
}
