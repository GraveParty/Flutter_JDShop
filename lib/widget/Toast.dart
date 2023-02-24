// ignore_for_file: file_names
import 'package:fluttertoast/fluttertoast.dart';

void toastMessage(String? message) {
  if (message == null || message.isEmpty) {
    return;
  }
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
  );
}
