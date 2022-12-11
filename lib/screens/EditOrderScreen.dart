import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:techoffice/models/Order.dart';
import 'package:techoffice/providers/OrdersProvider.dart';
import 'package:techoffice/utils/Dialogs.dart';

class EditOrderScreen extends StatelessWidget {
  final numberController = TextEditingController();
  final projectController = TextEditingController();
  final countController = TextEditingController();
  final finishingController = TextEditingController();
  final materialController = TextEditingController();
  final unitController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey();

  final ValueNotifier<String> orderDate = ValueNotifier("N/A");
  final Order order;

  EditOrderScreen({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initOrder();

    return Scaffold(
      appBar: AppBar(
        title: Text("اوردر جديد"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "ادخل رقم الاوردر";
                    }

                    if (int.tryParse(value) == null) {
                      return "ادخل رقم صالح";
                    }

                    if (int.parse(value) <= 0) {
                      return "ادخل قيمة صالحة";
                    }

                    return null;
                  },
                  controller: numberController,
                  autocorrect: true,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: "رقم الاوردر *"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (int.tryParse(value) != null) {
                        return "ادخل اسم المشروع وليس رقم";
                      }

                      if (value.length <= 2) {
                        return "ادخل قيمة صالحة للمشروع";
                      }
                    }

                    return null;
                  },
                  controller: projectController,
                  autocorrect: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: "المشروع"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "ادخل الكمية المطلوبة";
                    }

                    if (double.tryParse(value) == null) {
                      return "ادخل رقم صالح";
                    }

                    if (double.parse(value) <= 0) {
                      return "ادخل قيمة صالحة للكمية";
                    }

                    return null;
                  },
                  controller: countController,
                  autocorrect: true,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "الكمية المطلوبة *"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "ادخل الوحدة";
                    }

                    if (int.tryParse(value) != null) {
                      return "ادخل نص صالح للوحدة";
                    }

                    return null;
                  },
                  controller: unitController,
                  autocorrect: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: "الوحدة *"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (int.tryParse(value) != null) {
                        return "ادخل نص صالح للخامة";
                      }

                      if (value.length <= 2) {
                        return "ادخل قيمة صالحة للخامة";
                      }
                    }

                    return null;
                  },
                  controller: materialController,
                  autocorrect: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: "الخامة"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value.isNotEmpty) {
                      if (int.tryParse(value) != null) {
                        return "ادخل نص صالح للتشطيب";
                      }

                      if (value.length <= 2) {
                        return "ادخل قيمة صالحة للتشطيب";
                      }
                    }

                    return null;
                  },
                  controller: finishingController,
                  autocorrect: true,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    openOrderDate(context);
                  },
                  decoration: InputDecoration(labelText: "التشطيب"),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton.icon(
                  onPressed: () async {
                    openOrderDate(context);
                  },
                  icon: Icon(FlutterIcons.calendar_edit_mco),
                  label: ValueListenableBuilder(
                    valueListenable: orderDate,
                    builder: (context, value, child) => Text.rich(TextSpan(
                      text: "تاريخ الاوردر",
                      children: [
                        TextSpan(
                          text: " * ",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        TextSpan(text: value),
                      ],
                    )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                Text.rich(TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(text: " : عناصر مطلوبة"),
                  ],
                )),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RaisedButton.icon(
                        color: Theme.of(context).primaryColorLight,
                        onPressed: () async {
                          if (!formKey.currentState.validate()) {
                            return;
                          }

                          // validate date
                          if (orderDate.value == null ||
                              orderDate.value.isEmpty ||
                              orderDate.value == "N/A") {
                            return errorAlert(context, "اختار تاريخ الاوردر");
                          }

                          await Provider.of<OrdersProvider>(context,
                                  listen: false)
                              .updateOrder(
                                  context,
                                  Order(
                                      id: order.id,
                                      number: int.parse(numberController.text),
                                      count: double.parse(
                                          countController.text ?? "0"),
                                      finishing: finishingController.text,
                                      material: materialController.text,
                                      project: projectController.text,
                                      unit: unitController.text,
                                      order_date: orderDate.value));
                        },
                        icon: Icon(Icons.save),
                        label: Text("تحديث"),
                        padding: EdgeInsets.symmetric(vertical: 7),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  openOrderDate(context) async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      orderDate.value = "${date.year}-${date.month}-${date.day}";
    }
  }

  void initOrder() {
    this.numberController.text = order.number.toString();
    this.unitController.text = order.unit;
    this.countController.text = order.count.toString();
    this.projectController.text = order.project;
    this.finishingController.text = order.finishing;
    this.materialController.text = order.material;
    this.orderDate.value = order.order_date;
  }
}
