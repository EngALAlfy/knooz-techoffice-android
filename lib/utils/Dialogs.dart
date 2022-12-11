import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:techoffice/widgets/IsLoadingWidget.dart';

errorAlert(context, error, {Function fun, errorTitle: "خطأ", ok: "اوك"}) {
  Alert(
      type: AlertType.error,
      context: context,
      desc: error,
      title: errorTitle,
      buttons: [
        DialogButton(
            child: Text(ok),
            onPressed: () {
              Navigator.pop(context);
              if (fun != null) {
                fun();
              }
            })
      ]).show();
}

successAlert(context,
    {message, Function fun, successTitle: "تم بنجاح", ok: "اوك"}) {
  Alert(
      type: AlertType.success,
      context: context,
      desc: message,
      title: successTitle,
      buttons: [
        DialogButton(
            child: Text(ok),
            onPressed: () {
              Navigator.pop(context);
              if (fun != null) {
                fun();
              }
            })
      ]).show();
}

snackBar(context, message, {AlertType type: AlertType.info}) {
  final ScaffoldMessengerState scaffoldMessenger =
      ScaffoldMessenger.of(context);
  scaffoldMessenger.showSnackBar(
    SnackBar(
      duration: Duration(seconds: 2),
      content: Text(message),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      backgroundColor: type == AlertType.error
          ? Colors.redAccent
          : type == AlertType.success
              ? Colors.greenAccent
              : type == AlertType.info
                  ? Colors.blueAccent
                  : type == AlertType.warning
                      ? Colors.orangeAccent
                      : Colors.black,
    ),
  );
}

loadingAlert(context, {Function fun, hint: false}) {
  Alert(
    context: context,
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IsLoadingWidget(),
        SizedBox(
          width: 5,
        ),
        if (hint) Text("جاري التحميل ..."),
      ],
    ),
    style: AlertStyle(
        alertPadding: EdgeInsets.zero,
        isOverlayTapDismiss: false,
        isCloseButton: false,
        isButtonVisible: false),
  ).show();
}

soon() {
  EasyLoading.showToast("قريبا");
}
