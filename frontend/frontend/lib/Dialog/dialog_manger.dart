import 'package:flutter/material.dart';
import 'package:frontend/Dialog/dialog_service.dart';
import 'package:frontend/Dialog/alert_request.dart';
import 'package:frontend/Dialog/alert_response.dart';
import 'package:frontend/locator.dart';
import 'package:json_editor/json_editor.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class DialogManager extends StatefulWidget {
  final Widget child;
  const DialogManager({Key? key, required this.child}) : super(key: key);

  @override
  State<DialogManager> createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  final DialogService _dialogService = locator<DialogService>();
  final dark = JsonTheme(
      defaultStyle: const TextStyle(color: Colors.white, fontSize: 14),
      bracketStyle: const TextStyle(color: Colors.white70, fontSize: 14),
      numberStyle: TextStyle(color: Colors.blue.shade500, fontSize: 14),
      stringStyle: const TextStyle(color: Colors.purple, fontSize: 14),
      boolStyle: TextStyle(color: Colors.orange.shade800, fontSize: 14),
      keyStyle: TextStyle(color: Colors.blueGrey.shade200, fontSize: 14),
      commentStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      errorStyle: TextStyle(
          color: Colors.red.shade600,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline));
  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(AlertRequest request) {
    Alert(
      context: context,
      content: SingleChildScrollView(
        child: SizedBox(
          height: 300,
          width: 500,
          child: JsonEditorTheme(
              themeData: JsonEditorThemeData(darkTheme: dark, lightTheme: JsonTheme.light()),
              child: JsonEditor.string(
                enabled: false,
                jsonString: request.data,
              )),
        ),
      ),
      buttons: [
        DialogButton(
          onPressed: () => [
            _dialogService.dialogComplete(AlertResponse(confirmed: true)),
            Navigator.of(context).pop()
          ],
          width: 120,
          child: const Text(
            "close",
            style: TextStyle(color: Colors.purple, fontSize: 20),
          ),
        )
      ],
    ).show();
  }
}
