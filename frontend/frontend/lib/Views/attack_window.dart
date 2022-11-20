import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/Core/JsonModel/sniffer_data_json_model.dart';
import 'package:frontend/Core/ViewModel/attack_view_model.dart';
import 'package:frontend/Core/ViewModel/custom_app_view_model2.dart';
import 'package:frontend/Dialog/dialog_service.dart';
import 'package:frontend/locator.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tabler_icons/tabler_icons.dart';

class AttackWindow extends StatelessWidget {
  const AttackWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveRowColumn(
      layout: ResponsiveRowColumnType.COLUMN,
      children: [
        ResponsiveRowColumnItem(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * (1 / 10),
            child: Consumer<AttackViewModel>(builder: (context, value, child) {
              return ResponsiveRowColumn(
                layout: ResponsiveRowColumnType.ROW,
                rowMainAxisAlignment: MainAxisAlignment.spaceAround,
                rowCrossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ResponsiveRowColumnItem(child: Text("Host ip -")),
                  ResponsiveRowColumnItem(
                    child: value.ipvals.isNotEmpty
                        ? DropdownButton(
                            value: value.src,
                            items: value.ipvals
                                .map((e) => DropdownMenuItem<IpWithMac>(
                                      value: e,
                                      child: Text(e.ip),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              value.src = val as IpWithMac;
                              value.updateSrcIpandMac();
                              Provider.of<CustomAppViewModel2>(context, listen: false)
                                  .getServerData();
                            },
                          )
                        : const CircularProgressIndicator(
                            color: Colors.purple,
                          ),
                  ),
                  ResponsiveRowColumnItem(child: Text("Mac- ${value.src.mac}")),
                  const ResponsiveRowColumnItem(child: Text("Vicitim ip -")),
                  ResponsiveRowColumnItem(
                    child: value.ipvals.isNotEmpty
                        ? DropdownButton(
                            value: value.dst,
                            items: value.ipvals
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.ip),
                                    ))
                                .toList(),
                            onChanged: (val) => [
                              value.dst = val!,
                              value.updateDstIpandMac(),
                              Provider.of<CustomAppViewModel2>(context, listen: false)
                                  .getServerData()
                            ],
                          )
                        : const CircularProgressIndicator(
                            color: Colors.purple,
                          ),
                  ),
                  ResponsiveRowColumnItem(child: Text("Mac- ${value.dst.mac}.")),
                  ResponsiveRowColumnItem(
                    child: IconButton(
                      icon: const Icon(
                        TablerIcons.playerPlay,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Provider.of<AttackViewModel>(context, listen: false).startSnifing();
                      },
                    ),
                  ),
                  ResponsiveRowColumnItem(
                    child: IconButton(
                      icon: const Icon(
                        TablerIcons.playerStop,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Provider.of<AttackViewModel>(context, listen: false).stopSnifing();
                      },
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        ResponsiveRowColumnItem(
          child: Consumer<AttackViewModel>(
            builder: (context, value, child) => value.allipsAreUpdate
                ? ResponsiveRowColumn(
                    layout: ResponsiveRowColumnType.ROW,
                    rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ResponsiveRowColumnItem(
                        child: ElevatedButton(
                          onPressed:
                              value.masterButton && (value.arpWithScapy && value.arpWithEtherCap)
                                  ? () async {
                                      await value.scapyStartOrStop();
                                    }
                                  : null,
                          style:
                              ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.green;
                              }
                              if (!value.arpWithScapy) {
                                return Colors.grey;
                              }
                              return Colors.purple;
                            },
                          )),
                          child: const Text("Start ARP With Scapy"),
                        ),
                      ),
                      ResponsiveRowColumnItem(
                        child: ElevatedButton(
                          onPressed: value.masterButton && !value.arpWithScapy
                              ? () async {
                                  await value.scapyStartOrStop();
                                }
                              : null,
                          style:
                              ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.green;
                              }
                              if (value.arpWithScapy) {
                                return Colors.grey;
                              }
                              return Colors.purple;
                            },
                          )),
                          child: const Text("Stop ARP With Scapy"),
                        ),
                      ),
                      ResponsiveRowColumnItem(
                        child: ElevatedButton(
                          onPressed: value.arpWithEtherCap && value.arpWithScapy
                              ? () async {
                                  await value.checkAndStartArpWithEtherCap();
                                }
                              : null,
                          style:
                              ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.green;
                              }
                              if (!value.arpWithEtherCap) {
                                return Colors.grey;
                              }
                              return Colors.purple;
                            },
                          )),
                          child: const Text("Start ARP With EtherCap"),
                        ),
                      ),
                      ResponsiveRowColumnItem(
                        child: ElevatedButton(
                          onPressed: !value.arpWithEtherCap
                              ? () async {
                                  await value.checkAndStartArpWithEtherCap();
                                }
                              : null,
                          style:
                              ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith<Color>(
                            (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors.green;
                              }
                              if (value.arpWithEtherCap) {
                                return Colors.grey;
                              }
                              return Colors.purple;
                            },
                          )),
                          child: const Text("Stop ARP With EtherCap"),
                        ),
                      ),
                    ],
                  )
                : const Center(child: Text("Please choose Host Ip And Victim Ip")),
          ),
        ),
        ResponsiveRowColumnItem(
            child: Text("Packet Recived - ${Provider.of<AttackViewModel>(context).vals.length}")),
        ResponsiveRowColumnItem(
          child: Expanded(
            child: Container(
              height: 200,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.only(left: 20),
              child: Consumer<AttackViewModel>(
                builder: (context, value, child) => ListView.builder(
                  reverse: true,
                  itemCount: value.vals.length,
                  itemBuilder: (context, index) => NewWidget(index: value.vals[index]),
                  padding: const EdgeInsets.all(5),
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({Key? key, required this.index}) : super(key: key);
  final SnifferDataJsonModel index;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: SizedBox(
        height: 150,
        child: ResponsiveRowColumn(
          layout: ResponsiveRowColumnType.COLUMN,
          columnCrossAxisAlignment: CrossAxisAlignment.start,
          columnMainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ResponsiveRowColumnItem(
              child: Container(
                  height: 30,
                  padding: const EdgeInsets.only(left: 20),
                  child: ResponsiveRowColumn(
                    layout: ResponsiveRowColumnType.ROW,
                    rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ResponsiveRowColumnItem(
                        child: Text(
                            "IP src=${index.iP?.src}   dst=${index.iP?.dst}   protocol - ${index.iP?.proto} Length=${index.iP?.len}"),
                      ),
                      ResponsiveRowColumnItem(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text("${index.time}"),
                        ),
                      ),
                    ],
                  )),
            ),
            ResponsiveRowColumnItem(
              child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                      "TCP [ACK] Seq=${index.tCP?.seq} Ack=${index.tCP?.ack} Win=${index.tCP?.window} Len=${index.iP?.len}  sport=${index.tCP?.sport} dport=${index.tCP?.dport} ")),
            ),
            if (index.hTTPRequest != null)
              ResponsiveRowColumnItem(
                child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("HTTP  ${index.hTTPRequest?.method}  / ${index.hTTPRequest?.path}"),
                ),
              ),
            ResponsiveRowColumnItem(
              child: Padding(
                padding: const EdgeInsets.only(left: 25),
                child: TextButton(
                  child: const Text("Show Raw Data"),
                  onPressed: () {
                    locator.get<DialogService>().showDialog(data: json.encode(index.toJson()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
