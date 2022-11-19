import 'package:flutter/material.dart';
import 'package:frontend/Core/ViewModel/custom_app_view_model.dart';
import 'package:frontend/Core/ViewModel/custom_app_view_model2.dart';
import 'package:frontend/Core/ViewModel/network_speed_viewmodel.dart';
import 'package:frontend/locator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tabler_icons/tabler_icons.dart';
import '../Graphs/netspeed.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget get child => Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade800,
              offset: const Offset(0.0, 1.0), //(x,y)
              blurRadius: 1.0,
            ),
          ],
          color: ThemeData.dark().primaryColorDark,
        ),
        child: SizedBox(
          height: 50,
          child: Consumer<CustomAppViewModel>(
            builder: (context, value, child) => ResponsiveRowColumn(
              layout: ResponsiveRowColumnType.ROW,
              rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
              rowCrossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ResponsiveRowColumnItem(
                  child: Container(
                    alignment: Alignment.center,
                    child: Card(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          alignment: Alignment.center,
                          dropdownColor: ThemeData.dark().drawerTheme.backgroundColor,
                          value: value.ifaceValue,
                          items: value.ifaces
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ),
                              )
                              .toList(),
                          elevation: 2,
                          onChanged: ((val) {
                            value.ifaceValue = val!;
                            Provider.of<CustomAppViewModel2>(context, listen: false)
                                .updateIfaceName(value.ifaceValue);
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Connect Server IP - ${value.wifiIP}"),
                  ),
                ),
                const ResponsiveRowColumnItem(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: LineChartSample10(),
                  ),
                ),
                const ResponsiveRowColumnItem(
                  child: SizedBox(
                    width: 10,
                  ),
                ),
                const ResponsiveRowColumnItem(
                  child: ResponsiveRowColumn(
                    columnCrossAxisAlignment: CrossAxisAlignment.center,
                    columnMainAxisAlignment: MainAxisAlignment.center,
                    columnSpacing: 8,
                    layout: ResponsiveRowColumnType.COLUMN,
                    children: [
                      ResponsiveRowColumnItem(
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: Colors.purpleAccent,
                          size: 10,
                        ),
                      ),
                      ResponsiveRowColumnItem(
                        child: Icon(
                          Icons.arrow_downward_outlined,
                          color: Colors.purpleAccent,
                          size: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Consumer<NetWorkSpeedViewModel>(
                        builder: (context, value, child) => ResponsiveRowColumn(
                          layout: ResponsiveRowColumnType.COLUMN,
                          columnMainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ResponsiveRowColumnItem(
                              child: Text("${value.dow} mbps"),
                            ),
                            ResponsiveRowColumnItem(
                              child: Text("${value.up} mbps"),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () => locator.get<CustomAppViewModel2>().getServerData(),
                      icon: Icon(TablerIcons.refresh),
                    ),
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: Consumer<CustomAppViewModel2>(
                    builder: (context, value, child) => ResponsiveRowColumn(
                      layout: ResponsiveRowColumnType.COLUMN,
                      columnCrossAxisAlignment: CrossAxisAlignment.center,
                      columnMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ResponsiveRowColumnItem(
                          child: ResponsiveRowColumn(
                            layout: ResponsiveRowColumnType.ROW,
                            rowCrossAxisAlignment: CrossAxisAlignment.center,
                            rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ResponsiveRowColumnItem(child: Text("Src ip - ${value.data.srcIp} ")),
                              ResponsiveRowColumnItem(child: Text("Src Mac -${value.data.srcmac}"))
                            ],
                          ),
                        ),
                        ResponsiveRowColumnItem(
                          child: ResponsiveRowColumn(
                            layout: ResponsiveRowColumnType.ROW,
                            rowCrossAxisAlignment: CrossAxisAlignment.center,
                            rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ResponsiveRowColumnItem(child: Text("Dst ip - ${value.data.dstIp} ")),
                              ResponsiveRowColumnItem(child: Text("Dst Mac -${value.data.dstmac}"))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: Consumer<CustomAppViewModel2>(
                    builder: (context, value, child) => Icon(
                      TablerIcons.power,
                      color: value.socketConnectionStatus ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
