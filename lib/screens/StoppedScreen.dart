import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:techoffice/providers/OrdersProvider.dart';
import 'package:techoffice/screens/OrderScreen.dart';
import 'package:techoffice/utils/Navigate.dart';
import 'package:techoffice/widgets/IsEmptyWidget.dart';
import 'package:techoffice/widgets/IsErrorWidget.dart';
import 'package:techoffice/widgets/IsLoadingWidget.dart';

class StoppedScreen extends StatelessWidget {
  const StoppedScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrdersProvider>(context, listen: false).getStoppedOrders();
    return Scaffold(
      appBar: AppBar(
        title: Text("الاوردرات (الموقوفة)"),
        centerTitle: true,
      ),
      body: Consumer<OrdersProvider>(
        builder: (_, db, __) {
          if (db.stoppedOrdersResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (db.stoppedOrdersResponse.isEmpty) {
            return IsEmptyWidget();
          }

          if (db.stoppedOrdersResponse.isError) {
            return IsErrorWidget(
              error: db.stoppedOrdersResponse.error.serverMessage.toString(),
            );
          }

          return ListView.separated(
              padding: EdgeInsets.only(bottom: 100),
              itemBuilder: (context, index) {
                String donePercent = "0";
                String shippedPercent = "0";

                if (db.stoppedOrdersResponse.data
                            .elementAt(index)
                            .shipped_count !=
                        null &&
                    db.stoppedOrdersResponse.data.elementAt(index).count !=
                        null) {
                  shippedPercent = ((db.stoppedOrdersResponse.data
                                  .elementAt(index)
                                  .shipped_count /
                              db.stoppedOrdersResponse.data
                                  .elementAt(index)
                                  .count) *
                          100)
                      .toStringAsFixed(0);
                }

                if (db.stoppedOrdersResponse.data.elementAt(index).done_count !=
                        null &&
                    db.stoppedOrdersResponse.data.elementAt(index).count !=
                        null) {
                  donePercent = ((db.stoppedOrdersResponse.data
                                  .elementAt(index)
                                  .done_count /
                              db.stoppedOrdersResponse.data
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
                            stopped: true));
                  },
                  leading: Icon(Icons.crop_square),
                  title: Text(
                      "امر تصنيع رقم ${db.stoppedOrdersResponse.data.elementAt(index).number} ( ${db.stoppedOrdersResponse.data.elementAt(index).project} )"),
                  subtitle: Text("نسبة المنتج : $donePercent%"),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: db.stoppedOrdersResponse.data.length);
        },
      ),
    );
  }
}
