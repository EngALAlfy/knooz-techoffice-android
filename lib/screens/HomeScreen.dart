import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:techoffice/providers/OrdersProvider.dart';
import 'package:techoffice/screens/ArchiveScreen.dart';
import 'package:techoffice/screens/FinishedScreen.dart';
import 'package:techoffice/screens/NewOrderScreen.dart';
import 'package:techoffice/screens/OrderScreen.dart';
import 'package:techoffice/screens/SettingsScreen.dart';
import 'package:techoffice/screens/StoppedScreen.dart';
import 'package:techoffice/screens/TablesScreen.dart';
import 'package:techoffice/utils/Dialogs.dart';
import 'package:techoffice/utils/Navigate.dart';
import 'package:techoffice/widgets/DividerWithText.dart';
import 'package:techoffice/widgets/IsEmptyWidget.dart';
import 'package:techoffice/widgets/IsErrorWidget.dart';
import 'package:techoffice/widgets/IsLoadingWidget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrdersProvider>(context, listen: false).getCurrentOrders();
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Container(
                color: Colors.white,
                child: Image.asset("assets/images/knooz.png"),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.insert_chart_outlined_sharp),
                    title: Text("الموقف التنفيذي"),
                    onTap: () {
                      goTo(context, TablesScreen());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.check_circle_outline_outlined),
                    title: Text("الاوردرات المنتهية"),
                    onTap: () {
                      goTo(context, FinishedScreen());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.remove_circle_outline_outlined),
                    title: Text("الاوردرات الموقوفة"),
                    onTap: () {
                      goTo(context, StoppedScreen());
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.archive_outlined),
                    title: Text("الارشيف"),
                    onTap: () {
                      goTo(context, ArchiveScreen());
                    },
                  ),
                  DividerWithText(
                    text: "الورشة",
                  ),
                  ListTile(
                    leading: Icon(FlutterIcons.question_circle_o_faw),
                    title: Text("حالة الماكينات"),
                    onTap: () => soon(),
                  ),
                  DividerWithText(
                    text: "تخطيط",
                  ),
                  ListTile(
                    leading: Icon(Icons.calculate_outlined),
                    title: Text("حاسبة انتاجية البلوك"),
                    onTap: () => soon(),
                  ),
                  DividerWithText(
                    text: "التطبيق",
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("اعدادات"),
                    onTap: () => goTo(context, SettingsScreen()),
                  ),
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text("حول"),
                    onTap: () => soon(),
                  ),
                  ListTile(
                    onTap: () {
                      SystemNavigator.pop(animated: true);
                    },
                    leading: Icon(Icons.exit_to_app),
                    title: Text("خروج"),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("الاوردرات (الحالية)"),
        centerTitle: true,
      ),
      body: Consumer<OrdersProvider>(
        builder: (_, db, __) {
          if (db.currentOrdersResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (db.currentOrdersResponse.isError) {
            return IsErrorWidget(
              error: db.currentOrdersResponse.error.toString(),
              onRetry: () {
                db.getCurrentOrders();
                db.notify();
              },
            );
          }

          if (db.currentOrdersResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return ListView.separated(
              padding: EdgeInsets.only(bottom: 100),
              itemBuilder: (context, index) {
                String donePercent = "0";

                if (db.currentOrdersResponse.data.elementAt(index).done_count !=
                        null &&
                    db.currentOrdersResponse.data.elementAt(index).count !=
                        null) {
                  donePercent = ((db.currentOrdersResponse.data
                                  .elementAt(index)
                                  .done_count /
                              db.currentOrdersResponse.data
                                  .elementAt(index)
                                  .count) *
                          100)
                      .toStringAsFixed(0);
                }

                return ListTile(
                  onTap: () {
                    goTo(
                        context,
                        OrderScreen(
                          index: index,
                        ));
                  },
                  leading: Icon(Icons.crop_square),
                  title: Text(
                      "امر تصنيع رقم ${db.currentOrdersResponse.data.elementAt(index).number} ( ${db.currentOrdersResponse.data.elementAt(index).project} )"),
                  subtitle: Text("نسبة المنتج : $donePercent%"),
                );

                /*
        
                return ExpansionTile(
                  leading: Icon(Icons.crop_square),
                  title: Text(
                      "امر تصنيع رقم ${db.currentOrdersResponse.data.elementAt(index).number} ( ${db.currentOrdersResponse.data.elementAt(index).project} )"),
                  subtitle: Text("نسبة المنتج : $donePercent%"),
                  children: [
                    ListTile(
                      title: Text(
                          "رقم الاوردر : ${db.currentOrdersResponse.data.elementAt(index).number ?? "--"}"),
                    ),
                    ListTile(
                      title: Text(
                          "المشروع : ${db.currentOrdersResponse.data.elementAt(index).project ?? "--"}"),
                    ),
                    ListTile(
                      title: Text(
                          "تاريخ امر التصنيع : ${db.currentOrdersResponse.data.elementAt(index).order_date ?? "--"}"),
                    ),
                    ListTile(
                      title: Text(
                          "تاريخ البدء : ${db.currentOrdersResponse.data.elementAt(index).start_date ?? "--"}"),
                    ),
                    ListTile(
                      title: Text(
                          "تاريخ الانتهاء : ${db.currentOrdersResponse.data.elementAt(index).finish_date ?? "--"}"),
                    ),
                    ListTile(
                      title: Text(
                          "الخامة : ${db.currentOrdersResponse.data.elementAt(index).material ?? "--"}"),
                    ),
                    ListTile(
                      title: Text(
                          "التشطيب : ${db.currentOrdersResponse.data.elementAt(index).finishing ?? "--"}"),
                    ),
                    ListTile(
                      title: Text(
                          "الكمية المطلوبة : ${db.currentOrdersResponse.data.elementAt(index).count ?? "--"} ${db.currentOrdersResponse.data.elementAt(index).unit}"),
                    ),
                    ListTile(
                      title: Text(
                          "كمية المنتج : ${db.currentOrdersResponse.data.elementAt(index).done_count ?? "--"} ${db.currentOrdersResponse.data.elementAt(index).unit}"),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          TextEditingController _controller =
                              TextEditingController();
                          Alert(
                              context: context,
                              content: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "الكمية المنتجة",
                                ),
                              ),
                              buttons: [
                                DialogButton(
                                    child: Text("تحديث"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      db.updateDone(
                                          context,
                                          db.currentOrdersResponse.data
                                              .elementAt(index)
                                              .id,
                                          int.parse(_controller.text));
                                    }),
                              ]).show();
                        },
                      ),
                    ),
                    ListTile(
                      title: Text("نسبة المنتج : $donePercent%"),
                    ),
                    ListTile(
                      title: Text(
                          "كمية الصادر : ${db.currentOrdersResponse.data.elementAt(index).shipped_count ?? '--'}  ${db.currentOrdersResponse.data.elementAt(index).unit}"),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          TextEditingController _controller =
                              TextEditingController();
                          Alert(
                              context: context,
                              content: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "الكمية الصادرة",
                                ),
                              ),
                              buttons: [
                                DialogButton(
                                    child: Text("تحديث"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      db.updateShipped(
                                          context,
                                          db.currentOrdersResponse.data
                                              .elementAt(index)
                                              .id,
                                          int.parse(_controller.text));

                                      if (int.parse(_controller.text) >=
                                          db.currentOrdersResponse.data
                                              .elementAt(index)
                                              .count) {
                                        EasyLoading.showInfo(
                                            "تم انتهاء الاوردر");
                                        db.finishOrder(
                                            context,
                                            db.currentOrdersResponse.data
                                                .elementAt(index)
                                                .id);
                                      }
                                    }),
                              ]).show();
                        },
                      ),
                    ),
                    ListTile(
                      title: Text("نسبة الصادر : $shippedPercent%"),
                    ),
                    ListTile(
                      title: Text("المشاكل"),
                      subtitle: Text(db.currentOrdersResponse.data
                              .elementAt(index)
                              .problems ??
                          "--"),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          TextEditingController _controller =
                              TextEditingController(
                                  text: db.currentOrdersResponse.data
                                      .elementAt(index)
                                      .problems);
                          Alert(
                              context: context,
                              content: TextField(
                                controller: _controller,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: "المشاكل",
                                ),
                              ),
                              buttons: [
                                DialogButton(
                                    child: Text("تحديث"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      db.updateProblems(
                                          context,
                                          db.currentOrdersResponse.data
                                              .elementAt(index)
                                              .id,
                                          _controller.text);
                                    }),
                              ]).show();
                        },
                      ),
                    ),
                    ListTile(
                      title: Text("ملاحظات"),
                      subtitle: Text(db.currentOrdersResponse.data
                              .elementAt(index)
                              .notes ??
                          "--"),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          TextEditingController _controller =
                              TextEditingController(
                                  text: db.currentOrdersResponse.data
                                      .elementAt(index)
                                      .notes);
                          Alert(
                              context: context,
                              content: TextField(
                                controller: _controller,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: "الملاحظات",
                                ),
                              ),
                              buttons: [
                                DialogButton(
                                    child: Text("تحديث"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      db.updateNotes(
                                          context,
                                          db.currentOrdersResponse.data
                                              .elementAt(index)
                                              .id,
                                          _controller.text);
                                    }),
                              ]).show();
                        },
                      ),
                    ),
                    Wrap(
                      spacing: 5,
                      //alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      children: [
                        RaisedButton.icon(
                          onPressed: () async {
                            Share.share(db.currentOrdersResponse.data
                                .elementAt(index)
                                .toString());
                          },
                          icon: Icon(Icons.share),
                          color: Colors.greenAccent,
                          label: Text("ارسال"),
                        ),
                        RaisedButton.icon(
                          onPressed: () async {},
                          icon: Icon(Icons.edit),
                          label: Text("تعديل"),
                        ),
                        RaisedButton.icon(
                          onPressed: () async {
                            db.stopOrder(
                                context,
                                db.currentOrdersResponse.data
                                    .elementAt(index)
                                    .id);
                          },
                          icon: Icon(Icons.stop),
                          color: Colors.grey,
                          label: Text("ايقاف"),
                        ),
                        RaisedButton.icon(
                          onPressed: () async {
                            db.deleteOrder(
                                context,
                                db.currentOrdersResponse.data
                                    .elementAt(index)
                                    .id);
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.redAccent,
                          label: Text("حذف"),
                        ),
                        RaisedButton.icon(
                          onPressed: () async {
                            db.archiveOrder(
                                context,
                                db.currentOrdersResponse.data
                                    .elementAt(index)
                                    .id);
                          },
                          icon: Icon(Icons.archive),
                          color: Colors.orangeAccent,
                          label: Text("ارشفة"),
                        ),
                      ],
                    ),
                  ],
                  expandedAlignment: Alignment.centerRight,
                  childrenPadding: EdgeInsets.symmetric(horizontal: 10),
                  expandedCrossAxisAlignment: CrossAxisAlignment.start,
                );
              
        */
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: db.currentOrdersResponse.data.length);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Entypo.plus),
        onPressed: () {
          goTo(context, NewOrderScreen());
        },
      ),
    );
  }
}
