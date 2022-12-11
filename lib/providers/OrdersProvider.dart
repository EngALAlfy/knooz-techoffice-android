import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';

import 'package:techoffice/api/APIResponse.dart';
import 'package:techoffice/api/APIs.dart';
import 'package:techoffice/api/URLs.dart';
import 'package:techoffice/models/Order.dart';
import 'package:techoffice/utils/Dialogs.dart';
import 'package:techoffice/screens/HomeScreen.dart';
import 'package:techoffice/utils/Navigate.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
//import 'package:intent/intent.dart' as intent;
//import 'package:intent/action.dart' as action;
//import 'package:android_intent_plus/android_intent.dart';
import 'package:open_file/open_file.dart';

class OrdersProvider extends ChangeNotifier {
  APIResponse currentOrdersResponse = APIResponse();
  APIResponse finishedOrdersResponse = APIResponse();
  APIResponse stoppedOrdersResponse = APIResponse();
  APIResponse archivedOrdersResponse = APIResponse();
  APIResponse tabledOrdersResponse = APIResponse();

  Future<void> insertOrder(context, Order order, File pdf, File dxf) async {
    loadingAlert(context, hint: true);

    var orderMap = order.toJson();
    if (pdf != null) {
      orderMap.addAll({
        'pdf_file': await MultipartFile.fromFile(pdf.path,
            filename: pdf.path.split("/").last),
      });
    }

    if (dxf != null) {
      orderMap.addAll({
        'dxf_file': await MultipartFile.fromFile(dxf.path,
            filename: dxf.path.split("/").last),
      });
    }

    var formData = FormData.fromMap(orderMap);

    var response = await APIs().postData(URLs.NEW_URL, data: formData);

    Navigator.pop(context);

    if (response.isError) {
      errorAlert(context, response.error.toString());
    } else {
      snackBar(context, "تم الاضافة بنجاح");
      goToRemove(context, HomeScreen());
    }

    await getCurrentOrders();
  }

  Future<void> updateDone(context, id, done) async {
    loadingAlert(context, hint: true);
    var response = await APIs()
        .postData(URLs.UPDATE_DONE_URL + "/$id", data: {'done_count': done});

    Navigator.pop(context);

    if (response.isError) {
      errorAlert(context, response.error.toString());
    } else {
      snackBar(context, "تم التحديث بنجاح");
    }

    await getCurrentOrders();
  }

  Future<void> updateShipped(context, id, shipped) async {
    loadingAlert(context, hint: true);
    var response = await APIs().postData(URLs.UPDATE_SHIPPED_URL + "/$id",
        data: {'shipped_count': shipped});

    Navigator.pop(context);

    if (response.isError) {
      errorAlert(context, response.error.toString());
    } else {
      snackBar(context, "تم التحديث بنجاح");
    }

    await getCurrentOrders();
  }

  Future<void> updateProblems(context, id, problems) async {
    loadingAlert(context, hint: true);
    var response = await APIs().postData(URLs.UPDATE_PROBLEMS_URL + "/$id",
        data: {'problems': problems});

    Navigator.pop(context);

    if (response.isError) {
      errorAlert(context, response.error.toString());
    } else {
      snackBar(context, "تم التحديث بنجاح");
    }

    await getCurrentOrders();
  }

  Future<void> updateNotes(context, id, notes) async {
    loadingAlert(context, hint: true);
    var response = await APIs()
        .postData(URLs.UPDATE_NOTES_URL + "/$id", data: {'notes': notes});

    Navigator.pop(context);

    if (response.isError) {
      errorAlert(context, response.error.toString());
    } else {
      snackBar(context, "تم التحديث بنجاح");
    }

    await getCurrentOrders();
  }

  Future<void> archiveOrder(context, id) async {
    loadingAlert(context, hint: true);
    var response = await APIs().getData(URLs.ARCHIVE_URL + "/$id");

    Navigator.pop(context);
    if (response.isError) {
      errorAlert(context, response.error.toString().toString());
    } else {
      snackBar(context, "تم الارشفة بنجاح");
      //go back
      Navigator.pop(context);
    }

    getCurrentOrders();
  }

  Future<void> stopOrder(context, id) async {
    loadingAlert(context, hint: true);
    var response = await APIs().getData(URLs.STOP_URL + "/$id");

    Navigator.pop(context);
    if (response.isError) {
      errorAlert(context, response.error.toString());
    } else {
      snackBar(context, "تم الايقاف بنجاح");
      //go back
      Navigator.pop(context);
    }

    getCurrentOrders();
    //getStoppedOrders();
  }

  Future<void> finishOrder(context, id) async {
    loadingAlert(context, hint: true);
    var response = await APIs().getData(URLs.FINISH_URL + "/$id");

    Navigator.pop(context);
    if (response.isError) {
      errorAlert(context, response.error.toString());
    } else {
      snackBar(context, "تم الانتهاء من الاوردر بنجاح");
      //go back
      Navigator.pop(context);
    }

    getCurrentOrders();
    getFinishedOrders();
  }

  Future<void> startOrder(context, id) async {
    loadingAlert(context, hint: true);
    var response = await APIs().getData(URLs.STRAT_URL + "/$id");

    Navigator.pop(context);
    if (response.isError) {
      errorAlert(context, response.error.toString());
    } else {
      snackBar(context, "تم بدء الاوردر بنجاح");
      //go back
      Navigator.pop(context);
    }

    getCurrentOrders();
    getStoppedOrders();
    getFinishedOrders();
  }

  Future<void> unArchiveOrder(context, id) async {
    loadingAlert(context, hint: true);
    var response = await APIs().getData(URLs.UNARCHIVE_URL + "/$id");

    Navigator.pop(context);
    if (response.isError) {
      errorAlert(context, response.error.toString());
    } else {
      snackBar(context, "تم الغاء الارشفة بنجاح");
      //go back
      Navigator.pop(context);
    }

    getCurrentOrders();
    getArchivedOrders();
  }

  getCurrentOrders() async {
    currentOrdersResponse.error = null;
    currentOrdersResponse.isError = false;

    var response = await APIs().getData(URLs.CURRENT_URL);

    if (response.isError) {
      currentOrdersResponse = response;
    } else {
      currentOrdersResponse.data = response.data
          .map((e) => e == null ? null : Order.fromJson(e))
          .toList();
    }

    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

  getTabledOrders() async {
    tabledOrdersResponse.error = null;
    tabledOrdersResponse.isError = false;

    var response = await APIs().getData(URLs.CURRENT_URL);

    if (response.isError) {
      tabledOrdersResponse = response;
    } else {
      tabledOrdersResponse.data = response.data
          .map((e) => e == null ? null : Order.fromJson(e))
          .toList();
    }

    notifyListeners();
  }

  getStoppedOrders() async {
    stoppedOrdersResponse.error = null;
    stoppedOrdersResponse.isError = false;

    var response = await APIs().getData(URLs.STOPPED_URL);

    if (response.isError) {
      stoppedOrdersResponse = response;
    } else {
      stoppedOrdersResponse.data = response.data
          .map((e) => e == null ? null : Order.fromJson(e))
          .toList();
    }

    notifyListeners();
  }

  getFinishedOrders() async {
    finishedOrdersResponse.error = null;
    finishedOrdersResponse.isError = false;
    var response = await APIs().getData(URLs.FINISHED_URL);

    if (response.isError) {
      finishedOrdersResponse = response;
    } else {
      finishedOrdersResponse.data = response.data
          .map((e) => e == null ? null : Order.fromJson(e))
          .toList();
    }

    notifyListeners();
  }

  getArchivedOrders() async {
    archivedOrdersResponse.error = null;
    archivedOrdersResponse.isError = false;

    var response = await APIs().getData(URLs.ARCHIVED_URL);

    if (response.isError) {
      archivedOrdersResponse = response;
    } else {
      archivedOrdersResponse.data = response.data
          .map((e) => e == null ? null : Order.fromJson(e))
          .toList();
    }

    notifyListeners();
  }

  Future<void> deleteOrder(context, id) async {
    loadingAlert(context, hint: true);
    var response = await APIs().getData(URLs.DELETE_URL + "/$id");

    Navigator.pop(context);
    if (response.isError) {
      errorAlert(context, response.error.toString());
    } else {
      snackBar(context, "تم الحذف بنجاح");
      //go back
      Navigator.pop(context);
    }

    getCurrentOrders();
    getFinishedOrders()();
    getStoppedOrders();
    getArchivedOrders();
  }

  void openPdfFile(BuildContext context, Order order) async {
    if (order.pdf_file == null) {
      errorAlert(context, "لا يوجد ملف لهذا الاوردر");
      return;
    }

    var orderDir = Directory(
        (await getExternalStorageDirectory()).path + "/office/${order.id}");

    if (await orderDir.exists()) {
      // check if file exist
      File pdfFile = File(orderDir.path + "/" + order.pdf_file);
      if ((await pdfFile.exists())) {
        // open
        // intent.Intent()
        //   ..setAction(action.Action.ACTION_VIEW)
        //   ..setData(Uri.dataFromString(Uri.encodeFull(pdfFile.path)))
        //   ..setType(pdfFile.path.split(".").last + "/*")
        //   ..startActivity().catchError((e) => print(e));

        // AndroidIntent intent = AndroidIntent(
        //   action: "action_view",
        //   data: Uri.encodeFull(pdfFile.path),
        //   type: "images/*",
        // );

        // intent.launchChooser("اختر برنامج لفت");

        OpenFile.open(pdfFile.path);
      } else {
        // download
        EasyLoading.showToast("جار تنزيل الملف");
        FlutterDownloader.registerCallback(downloaderCallback);

        final taskId = await FlutterDownloader.enqueue(
          url: URLs.PDF_URL + "/" + order.pdf_file,
          savedDir: orderDir.path,
          showNotification: true,
          fileName: order.pdf_file,
          openFileFromNotification: false,
        );
      }
    } else {
      // create + download
      await orderDir.create(recursive: true);

      // download
      EasyLoading.showToast("جار تنزيل الملف");
      FlutterDownloader.registerCallback(downloaderCallback);

      final taskId = await FlutterDownloader.enqueue(
        url: URLs.PDF_URL + "/" + order.pdf_file,
        savedDir: orderDir.path,
        saveInPublicStorage: true,
        fileName: order.pdf_file,
        showNotification: true,
        openFileFromNotification: false,
      );
    }
  }

  void updatePdfFile(BuildContext context, int id) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      dialogTitle: "اختر ملف pdf الاوردر",
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'xlx', 'xls', 'csv', 'jpg', 'jpeg'],
    );

    if (result != null) {
      File pdf = new File(result.files.single.path);

      loadingAlert(context, hint: true);

      var formData = FormData.fromMap({
        'pdf_file': await MultipartFile.fromFile(pdf.path,
            filename: pdf.path.split("/").last),
      });

      var response =
          await APIs().postData(URLs.UPDATE_PDF_URL + "/$id", data: formData);

      Navigator.pop(context);

      if (response.isError) {
        errorAlert(context, response.error.toString());
      } else {
        snackBar(context, "تم تحديث الملف بنجاح");
      }

      await getCurrentOrders();
    }
  }

  void openDxfFile(BuildContext context, Order order) async {
    if (order.dxf_file == null) {
      errorAlert(context, "لا يوجد ملف لهذا الاوردر");
      return;
    }

    var orderDir = Directory(
        (await getExternalStorageDirectory()).path + "/office/${order.id}");

    if (await orderDir.exists()) {
      // check if file exist
      File dxfFile = File(orderDir.path + "/" + order.dxf_file);
      if ((await dxfFile.exists())) {
        // open
        // intent.Intent()
        //   ..setAction(action.Action.ACTION_VIEW)
        //   ..setData(Uri.dataFromString(Uri.encodeFull(pdfFile.path)))
        //   ..setType(pdfFile.path.split(".").last + "/*")
        //   ..startActivity().catchError((e) => print(e));

        // AndroidIntent intent = AndroidIntent(
        //   action: "action_view",
        //   data: Uri.encodeFull(pdfFile.path),
        //   type: "images/*",
        // );

        // intent.launchChooser("اختر برنامج لفت");

        OpenFile.open(dxfFile.path);
      } else {
        // download
        EasyLoading.showToast("جار تنزيل الملف");
        FlutterDownloader.registerCallback(downloaderCallback);

        final taskId = await FlutterDownloader.enqueue(
          url: URLs.DXF_URL + "/" + order.dxf_file,
          savedDir: orderDir.path,
          showNotification: true,
          fileName: order.dxf_file,
          openFileFromNotification: false,
        );
      }
    } else {
      // create + download
      await orderDir.create(recursive: true);

      // download
      EasyLoading.showToast("جار تنزيل الملف");
      FlutterDownloader.registerCallback(downloaderCallback);

      final taskId = await FlutterDownloader.enqueue(
        url: URLs.DXF_URL + "/" + order.dxf_file,
        savedDir: orderDir.path,
        saveInPublicStorage: true,
        fileName: order.dxf_file,
        showNotification: true,
        openFileFromNotification: false,
      );
    }
  }

  void updateDxfFile(BuildContext context, int id) async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      dialogTitle: "اختر ملف dxf الاوردر",
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null) {
      File dxf = new File(result.files.single.path);

      loadingAlert(context, hint: true);

      var formData = FormData.fromMap({
        'dxf_file': await MultipartFile.fromFile(dxf.path,
            filename: dxf.path.split("/").last),
      });

      var response =
          await APIs().postData(URLs.UPDATE_DXF_URL + "/$id", data: formData);

      Navigator.pop(context);

      if (response.isError) {
        errorAlert(context, response.error.toString());
      } else {
        snackBar(context, "تم تحديث الملف بنجاح");
      }

      await getCurrentOrders();
    }
  }

  @pragma('vm:entry-point')
  static void downloaderCallback(id, DownloadTaskStatus status, progress) {
    print(progress);
    print(status);
  }

  updateOrder(BuildContext context, Order order) async {
    loadingAlert(context, hint: true);

    var orderMap = order.toJson();

    var formData = FormData.fromMap(orderMap);

    var response =
        await APIs().postData(URLs.UPDATE_URL + "/${order.id}", data: formData);
    print(URLs.UPDATE_URL + "/${order.id}");
    Navigator.pop(context);

    if (response.isError) {
      errorAlert(context, response.error.toString());
    } else {
      snackBar(context, "تم التحديث  بنجاح");
      Navigator.pop(context);
    }

    getCurrentOrders();
    getFinishedOrders()();
    getArchivedOrders();
    getStoppedOrders();
  }
}
