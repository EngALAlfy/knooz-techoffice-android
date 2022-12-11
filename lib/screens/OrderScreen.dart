import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'package:techoffice/models/Order.dart';
import 'package:techoffice/providers/OrdersProvider.dart';
import 'package:techoffice/screens/EditOrderScreen.dart';
import 'package:techoffice/utils/Navigate.dart';

class OrderScreen extends StatefulWidget {
  final int index;
  final bool finished;
  final bool archived;
  final bool stopped;
  OrderScreen(
      {Key key,
      this.index,
      this.finished = false,
      this.archived = false,
      this.stopped = false})
      : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<OrdersProvider>(context, listen: true);
    Order order;

    if (widget.archived) {
      order = db.archivedOrdersResponse.data.elementAt(widget.index);
    } else if (widget.finished) {
      order = db.finishedOrdersResponse.data.elementAt(widget.index);
    } else if (widget.stopped) {
      order = db.stoppedOrdersResponse.data.elementAt(widget.index);
    } else {
      order = db.currentOrdersResponse.data.elementAt(widget.index);
    }

    String donePercent = "0";
    String shippedPercent = "0";

    if (order.shipped_count != null && order.count != null) {
      shippedPercent =
          ((order.shipped_count / order.count) * 100).toStringAsFixed(0);
    }

    if (order.done_count != null && order.count != null) {
      donePercent = ((order.done_count / order.count) * 100).toStringAsFixed(0);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("امر تصنيع رقم ${order.number}"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 100),
        children: [
          ListTile(
            title: Text("رقم الاوردر : ${order.number ?? "--"}"),
          ),
          ListTile(
            title: Text("المشروع : ${order.project ?? "--"}"),
          ),
          ListTile(
            title: Text("تاريخ امر التصنيع : ${order.order_date ?? "--"}"),
          ),
          ListTile(
            title: Text("تاريخ البدء : ${order.start_date ?? "--"}"),
          ),
          ListTile(
            title: Text("تاريخ الانتهاء : ${order.finish_date ?? "--"}"),
          ),
          ListTile(
            title: Text("الخامة : ${order.material ?? "--"}"),
          ),
          ListTile(
            title: Text("التشطيب : ${order.finishing ?? "--"}"),
          ),
          ListTile(
            title: Text(
                "الكمية المطلوبة : ${order.count ?? "--"} ${order.unit ?? ""}"),
          ),
          ListTile(
            title: Text(
                "كمية المنتج : ${order.done_count ?? "--"} ${order.unit ?? ""}"),
            trailing: (widget.finished || widget.stopped || widget.archived)
                ? null
                : IconButton(
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
                                  db.updateDone(context, order.id,
                                      double.parse(_controller.text));
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
                "كمية الصادر : ${order.shipped_count ?? '--'}  ${order.unit ?? ""}"),
            trailing: (widget.finished || widget.stopped || widget.archived)
                ? null
                : IconButton(
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
                                  db.updateShipped(context, order.id,
                                      double.parse(_controller.text));

                                  if (double.parse(_controller.text) >=
                                      order.count) {
                                    EasyLoading.showInfo("تم انتهاء الاوردر");
                                    db.finishOrder(context, order.id);
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
            leading: Icon(FlutterIcons.pdf_box_mco),
            title: Text("ملف pdf الاوردر"),
            subtitle: Text(order.pdf_file ?? "--"),
            trailing: Wrap(
              children: [
                IconButton(
                    icon: Icon(Icons.folder_open_rounded),
                    onPressed: () {
                      db.openPdfFile(context, order);
                    }),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      db.updatePdfFile(context, order.id);
                    }),
              ],
            ),
          ),
          ListTile(
            leading: Icon(MaterialCommunityIcons.drawing_box),
            title: Text("ملف dxf الاوردر"),
            subtitle: Text(order.dxf_file ?? "--"),
            trailing: Wrap(
              children: [
                IconButton(
                    icon: Icon(Icons.folder_open_rounded),
                    onPressed: () {
                      db.openDxfFile(context, order);
                    }),
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      db.updateDxfFile(context, order.id);
                    }),
              ],
            ),
          ),
          ListTile(
            title: Text("المشاكل"),
            subtitle: Text(order.problems ?? "--"),
            trailing: (widget.finished || widget.stopped || widget.archived)
                ? null
                : IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                          TextEditingController(text: order.problems);
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
                                      context, order.id, _controller.text);
                                }),
                          ]).show();
                    },
                  ),
          ),
          ListTile(
            title: Text("ملاحظات"),
            subtitle: Text(order.notes ?? "--"),
            trailing: (widget.finished || widget.stopped || widget.archived)
                ? null
                : IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      TextEditingController _controller =
                          TextEditingController(text: order.notes);
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
                                      context, order.id, _controller.text);
                                }),
                          ]).show();
                    },
                  ),
          ),
          Wrap(
            alignment: WrapAlignment.spaceAround,
            spacing: 5,
            //alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            children: [
              RaisedButton.icon(
                onPressed: () async {
                  Share.share(order.toString());
                },
                icon: Icon(Icons.share),
                color: Colors.greenAccent,
                label: Text("ارسال"),
              ),
              RaisedButton.icon(
                onPressed: () async {
                  goTo(
                      context,
                      EditOrderScreen(
                        order: order,
                      ));
                },
                icon: Icon(Icons.edit),
                label: Text("تعديل"),
              ),
              if (!widget.archived && (widget.finished || widget.stopped))
                RaisedButton.icon(
                  onPressed: () async {
                    db.startOrder(context, order.id);
                  },
                  icon: Icon(Icons.play_arrow),
                  color: Colors.blueAccent,
                  label: Text("بدء"),
                )
              else if (!widget.archived)
                RaisedButton.icon(
                  onPressed: () async {
                    db.stopOrder(context, order.id);
                  },
                  icon: Icon(Icons.stop),
                  color: Colors.grey,
                  label: Text("ايقاف"),
                ),
              RaisedButton.icon(
                onPressed: () async {
                  db.deleteOrder(context, order.id);
                },
                icon: Icon(Icons.delete),
                color: Colors.redAccent,
                label: Text("حذف"),
              ),
              if (widget.archived)
                RaisedButton.icon(
                  onPressed: () async {
                    db.unArchiveOrder(context, order.id);
                  },
                  icon: Icon(Icons.unarchive),
                  color: Colors.orangeAccent,
                  label: Text("الغاء الارشفة"),
                )
              else
                RaisedButton.icon(
                  onPressed: () async {
                    db.archiveOrder(context, order.id);
                  },
                  icon: Icon(Icons.archive),
                  color: Colors.orangeAccent,
                  label: Text("ارشفة"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
