import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'package:techoffice/providers/OrdersProvider.dart';
import 'package:techoffice/screens/OrderScreen.dart';
import 'package:techoffice/utils/Navigate.dart';
import 'package:techoffice/widgets/IsEmptyWidget.dart';
import 'package:techoffice/widgets/IsErrorWidget.dart';
import 'package:techoffice/widgets/IsLoadingWidget.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrdersProvider>(context, listen: false).getArchivedOrders();
    return Scaffold(
      appBar: AppBar(
        title: Text("الارشيف"),
        centerTitle: true,
      ),
      body: Consumer<OrdersProvider>(
        builder: (_, db, __) {
          if (db.archivedOrdersResponse.isLoading) {
            return IsLoadingWidget();
          }

          if (db.archivedOrdersResponse.isEmpty) {
            return IsEmptyWidget();
          }

          if (db.archivedOrdersResponse.isError) {
            return IsErrorWidget(
              error: db.archivedOrdersResponse.error.serverMessage.toString(),
            );
          }

          return ListView.separated(
              padding: EdgeInsets.only(bottom: 100),
              itemBuilder: (context, index) {
                String donePercent = "0";
                String shippedPercent = "0";

                if (db.archivedOrdersResponse.data
                            .elementAt(index)
                            .shipped_count !=
                        null &&
                    db.archivedOrdersResponse.data.elementAt(index).count !=
                        null) {
                  shippedPercent = ((db.archivedOrdersResponse.data
                                  .elementAt(index)
                                  .shipped_count /
                              db.archivedOrdersResponse.data
                                  .elementAt(index)
                                  .count) *
                          100)
                      .toStringAsFixed(0);
                }

                if (db.archivedOrdersResponse.data
                            .elementAt(index)
                            .done_count !=
                        null &&
                    db.archivedOrdersResponse.data.elementAt(index).count !=
                        null) {
                  donePercent = ((db.archivedOrdersResponse.data
                                  .elementAt(index)
                                  .done_count /
                              db.archivedOrdersResponse.data
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
                            archived: true));
                  },
                  leading: Icon(Icons.crop_square),
                  title: Text(
                      "امر تصنيع رقم ${db.archivedOrdersResponse.data.elementAt(index).number} ( ${db.archivedOrdersResponse.data.elementAt(index).project} )"),
                  subtitle: Text("نسبة المنتج : $donePercent%"),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: db.archivedOrdersResponse.data.length);
        },
      ),
    );
  }
}
