import 'dart:async';

import 'package:frontend/Dialog/alert_request.dart';
import 'package:frontend/Dialog/alert_response.dart';

class DialogService {
  late Function(AlertRequest) _showDialogListener;
  late Completer<AlertResponse> _dialogCompleter;

  void registerDialogListener(Function(AlertRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  Future<AlertResponse> showDialog({required String data}) {
    _dialogCompleter = Completer<AlertResponse>();
    _showDialogListener(AlertRequest(
      data: data,
    ));
    return _dialogCompleter.future;
  }

  void dialogComplete(AlertResponse response) {
    _dialogCompleter.complete(response);
  }
}
