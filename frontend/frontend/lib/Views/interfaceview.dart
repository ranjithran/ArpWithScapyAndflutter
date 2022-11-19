import 'package:flutter/material.dart';
import 'package:frontend/Core/Db/ip_look_up.dart';
import 'package:frontend/locator.dart';

class TopTrafficView extends StatelessWidget {
  const TopTrafficView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          elevation: 2,
          child: DataTable(
            columnSpacing: 20,
            headingTextStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w800),
            dividerThickness: 2,
            columns: const [
              DataColumn(label: Text('ip')),
              DataColumn(label: Text('org')),
              DataColumn(label: Text('hostname')),
              DataColumn(label: Text('city')),
              DataColumn(label: Text('region')),
              DataColumn(label: Text('country')),
              DataColumn(label: Text('loc')),
            ],
            rows: locator
                .get<IpLookUpTable>()
                .unqiueIpLookUpValues
                .map(
                  ((element) => DataRow(
                        cells: <DataCell>[
                          DataCell(Text(element.ip!)), //Extracting from Map element the value
                          DataCell(Text(element.org!)),
                          DataCell(Text(element.hostname ?? "")),
                          DataCell(Text(element.city!)), //Extracting from Map element the value
                          DataCell(Text(element.region!)),
                          DataCell(Text(element.country!)),
                          DataCell(Text(element.loc!)), //Extracting from Map element the value
                        ],
                      )),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
