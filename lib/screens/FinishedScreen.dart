import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:techoffice/providers/OrdersProvider.dart';
import 'package:techoffice/screens/OrderScreen.dart';
import 'package:techoffice/utils/Navigate.dart';
import 'package:techoffice/widgets/IsEmptyWidget.dart';
import 'package:techoffice/widgets/IsErrorWidget.dart';
import 'package:techoffice/widgets/IsLoadingWidget.dart';

class FinishedScreen extends StatelessWidget {
  const FinishedScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrdersProvider>(context, listen: false).getFinishedOrders();
    return Scaffold(
      appBar: AppBar(
        title: Text("الاوردرات (المنتهية)"),
        centerTitle: true,
      ),
      body: Consumer<OrdersProvider>(
        builder: (_, db, __) {
          if (db.finishedOrdersResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (db.finishedOrdersResponse.isError) {
            return IsErrorWidget(
              error: db.finishedOrdersResponse.error.serverMessage.toString(),
            );
          }

          if (db.finishedOrdersResponse.isEmpty) {
            return IsEmptyWidget();
          }

          return ListView.separated(
              padding: EdgeInsets.only(bottom: 100),
              itemBuilder: (context, index) {
                String donePercent = "0";

                if (db.finishedOrdersResponse.data
                            .elementAt(index)
                            .done_count !=
                        null &&
                    db.finishedOrdersResponse.data.elementAt(index).count !=
                        null) {
                  donePercent = ((db.finishedOrdersResponse.data
                                  .elementAt(index)
                                  .done_count /
                              db.finishedOrdersResponse.data
                                  .elementAt(index)
                                  .count) *
                          100)
                      .toStringAsFixed(0);
                }

                return ListTile(
                  onTap: () {
                    goTo(context, OrderScreen(index: index, finished: true));
                  },
                  leading: Icon(Icons.crop_square),
                  title: Text(
                      "امر تصنيع رقم ${db.finishedOrdersResponse.data.elementAt(index).number} ( ${db.finishedOrdersResponse.data.elementAt(index).project} )"),
                  subtitle: Text("نسبة المنتج : $donePercent%"),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: db.finishedOrdersResponse.data.length);
        },
      ),
    );
  }
}
