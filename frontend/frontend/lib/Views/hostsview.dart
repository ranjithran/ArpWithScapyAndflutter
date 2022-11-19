import 'package:flutter/material.dart';
import 'package:frontend/Core/ViewModel/host_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tabler_icons/tabler_icons.dart';

class HostView extends StatelessWidget {
  const HostView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<VictimsViewModel>(
      create: (context) => VictimsViewModel(),
      builder: (context, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30, top: 50),
            height: 50,
            child: const Text(
              "All Hosts",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Expanded(
            child: ResponsiveRowColumn(
              layout: ResponsiveRowColumnType.COLUMN,
              columnCrossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ResponsiveRowColumnItem(
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () =>
                          Provider.of<VictimsViewModel>(context, listen: false).generateDataCells(),
                      icon: const Icon(TablerIcons.refresh),
                    ),
                  ),
                ),
                ResponsiveRowColumnItem(
                    child: Expanded(
                  child: Consumer<VictimsViewModel>(
                    builder: (context, value, child) => value.listofDataRows.isNotEmpty?SingleChildScrollView(
                      child: DataTable(
                        border: TableBorder(borderRadius: BorderRadius.circular(10)),
                        columns: const [
                          DataColumn(label: Text("IP Address")),
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Location")),
                          DataColumn(label: Text("Mac"))
                        ],
                        rows: Provider.of<VictimsViewModel>(context, listen: true).listofDataRows,
                      ),
                    ):Center(child: CircularProgressIndicator()),
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
