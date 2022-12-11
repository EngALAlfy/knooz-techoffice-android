import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:techoffice/models/Order.dart';
import 'package:techoffice/providers/OrdersProvider.dart';
import 'package:techoffice/widgets/IsEmptyWidget.dart';
import 'package:techoffice/widgets/IsErrorWidget.dart';
import 'package:techoffice/widgets/IsLoadingWidget.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({Key key}) : super(key: key);

  @override
  _TablesScreenState createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  final screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    Provider.of<OrdersProvider>(context, listen: false).getTabledOrders();
    return Scaffold(
      appBar: AppBar(
        title: Text("الموقف التنفيذي للاوردرات"),
        centerTitle: true,
      ),
      body: Consumer<OrdersProvider>(
        builder: (_, db, __) {
          if (db.tabledOrdersResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (db.tabledOrdersResponse.isEmpty) {
            return IsEmptyWidget();
          }
          if (db.tabledOrdersResponse.isError) {
            return IsErrorWidget(
              error: db.tabledOrdersResponse.error.serverMessage.toString(),
            );
          }

          return SingleChildScrollView(
            child: SingleChildScrollView(
              child: Screenshot(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 80,
                    ),
                    padding: EdgeInsets.only(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      top: 20,
                    ),
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Colors.black45,
                    child: Table(
                      //columnSpacing: 10,
                      //showBottomBorder: true,
                      //showCheckboxColumn: false,
                      //dividerThickness: 2,
                      //horizontalMargin: 5,
                      border: TableBorder.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      children: ordersList(context, db),
                      columnWidths: {
                        0: FixedColumnWidth(100),
                        1: FixedColumnWidth(100),
                        2: FixedColumnWidth(90),
                        3: FixedColumnWidth(90),
                        4: FixedColumnWidth(100),
                        5: IntrinsicColumnWidth(),
                        6: IntrinsicColumnWidth(),
                        7: MinColumnWidth(
                            IntrinsicColumnWidth(), FixedColumnWidth(200)),
                        8: MinColumnWidth(
                            IntrinsicColumnWidth(), FixedColumnWidth(200)),
                      },
                      defaultColumnWidth: IntrinsicColumnWidth(),
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                    ),
                  ),
                  controller: screenshotController),
              scrollDirection: Axis.vertical,
            ),
            scrollDirection: Axis.horizontal,
          );

/*
return Screenshot(
            controller: screenshotController,
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("التمام اليومي لاوردرات المكتب الفني"),
                      Text(
                          "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                Expanded(
                  child: JsonTable(
                    db.tabledOrders,
                    columns: [
                      JsonTableColumn("number",
                          label: "رقم", defaultValue: "--"),
                      JsonTableColumn("project",
                          label: "المشروع", defaultValue: "--"),
                      JsonTableColumn("material",
                          label: "الخامة", defaultValue: "--"),
                      JsonTableColumn("finishing",
                          label: "التشطيب", defaultValue: "--"),
                      JsonTableColumn("count",
                          label: "المطلوب", defaultValue: "--"),
                      JsonTableColumn("done_count",
                          label: "نسبة المنتج", defaultValue: "--"),
                      JsonTableColumn("shipped_count",
                          label: "نسبة الصادر", defaultValue: "--"),
                      JsonTableColumn("problems",
                          label: "المشاكل", defaultValue: "--"),
                      JsonTableColumn("notes",
                          label: "الملاحظات", defaultValue: "--"),
                    ],
                    allowRowHighlight: true,
                    showColumnToggle: false,
                    //paginationRowCount: 10,
                  ),
                ),
              ],
            ),
          );
*/
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          screenshotController
              .capture(pixelRatio: MediaQuery.of(context).devicePixelRatio)
              .then((value) async {
            if (value != null) {
              EasyLoading.showSuccess("تم حساب التمام بنجاح");

              final dir = await getApplicationDocumentsDirectory();
              final imageFile =
                  await File("${dir.path}/${DateTime.now()}.jpg").create();
              await imageFile.writeAsBytes(value);

              Share.shareFiles([imageFile.path],
                  text:
                      "الموقف التنفيذي لاوردرات المكتب الفني مصنع رخام 7 بتاريخ ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
            } else {
              EasyLoading.showError("خطأ في الصورة");
            }
          });
        },
        label: Text("ارسال"),
        icon: Icon(Icons.share),
      ),
    );
  }

  List<TableRow> ordersList(BuildContext context, OrdersProvider db) {
    List orders = db.tabledOrdersResponse.data;

    if (orders == null) {
      return [];
    }

    return List<TableRow>.generate(orders.length + 1, (index) {
      if (index == 0) {
        return TableRow(
          decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Color.fromRGBO(50, 80, 120, .8)
                  : Colors.lightBlue.shade200),
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "رقم الاوردر",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "المشروع",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "الخامة",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "التشطيب",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "الكمية المطلوبة",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "نسبة الانتاج",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "نسبة الصادر",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "المشاكل",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "الملاحظات",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      }

      String donePercent = "0";
      String shippedPercent = "0";

      if (db.tabledOrdersResponse.data.elementAt(index - 1).shipped_count !=
              null &&
          db.tabledOrdersResponse.data.elementAt(index - 1).count != null) {
        shippedPercent = ((db.tabledOrdersResponse.data
                        .elementAt(index - 1)
                        .shipped_count /
                    db.tabledOrdersResponse.data.elementAt(index - 1).count) *
                100)
            .toStringAsFixed(0);
      }

      if (db.tabledOrdersResponse.data.elementAt(index - 1).done_count !=
              null &&
          db.tabledOrdersResponse.data.elementAt(index - 1).count != null) {
        donePercent = ((db.tabledOrdersResponse.data
                        .elementAt(index - 1)
                        .done_count /
                    db.tabledOrdersResponse.data.elementAt(index - 1).count) *
                100)
            .toStringAsFixed(0);
      }

      return TableRow(children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "${orders.elementAt(index - 1).number}",
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "${orders.elementAt(index - 1).project ?? "--"}",
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "${orders.elementAt(index - 1).material ?? "--"}",
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "${orders.elementAt(index - 1).finishing ?? "--"}",
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "${orders.elementAt(index - 1).count ?? "--"}  ${orders.elementAt(index - 1).unit}",
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "$donePercent%",
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "$shippedPercent%",
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "${orders.elementAt(index - 1).problems ?? "--"}",
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "${orders.elementAt(index - 1).notes ?? "--"}",
          ),
        ),
      ]);
    });
  }
}
