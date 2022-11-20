import 'package:flutter/material.dart';
import 'package:frontend/Core/Db/packet_table.dart';
import 'package:frontend/Dialog/dialog_service.dart';
import 'package:frontend/locator.dart';

class PacketListView extends StatelessWidget {
  PacketListView({super.key});
  List<PacketModel> result = [];
  @override
  Widget build(BuildContext context) {
    result = locator.get<PacketTable>().getAll();
    return SingleChildScrollView(
      child: Container(
        child: DataTable(
          columns: const [
            DataColumn(label: Text("Src Ip")),
            DataColumn(label: Text("Src Mac")),
            DataColumn(label: Text("Dst Ip")),
            DataColumn(label: Text("Dst Mac")),
            DataColumn(label: Text("Created At")),
            DataColumn(label: Text("Show Raw Data"))
          ],
          rows: result.map((e) {
            return DataRow(
              cells: [
                DataCell(Text("${e.srcip}")),
                DataCell(Text("${e.srcMac}")),
                DataCell(Text("${e.dstip}")),
                DataCell(Text("${e.dstmac}")),
                DataCell(Text("${e.createddate}")),
                DataCell(
                  const Text("Show Raw"),
                  onTap: () => locator.get<DialogService>().showDialog(data: e.toJson().toString()),
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
