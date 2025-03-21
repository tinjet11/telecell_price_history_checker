import 'package:telecell_price_history_checker/data/datasources/api_services.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../models/sales_data_model.dart';
import 'package:intl/intl.dart'; // Import the date formatting library

@override
Future<List<SalesDataModel>> getSalesData(String debtor) async {
  final List<String> datelist = [];
  final List<String> invoicelist = [];
  final List<String> quantitylist = [];
  final List<String> unitpricelist = [];
  final List<String> stockcodelist = [];
  final List<String> stockfullnamelist = [];

  final QueryBuilder<ParseObject> parseQuery =
      await ApiServices("CustomerSalesHistory");

  parseQuery.setLimit(10000);
  parseQuery.whereEqualTo("Debtor", debtor);

  parseQuery.orderByDescending("Date");

  final apiResponse = await parseQuery.query();

  if (apiResponse.success && apiResponse.results != null) {
    for (var object in apiResponse.results as List<ParseObject>) {
      datelist.add('${object.get<String>('Date')}');
      invoicelist.add('${object.get<String>('Invoice')}');
      quantitylist.add('${object.get('Qty')}');
      unitpricelist.add('${object.get('UnitPrice')}');
      stockcodelist.add('${object.get('StockCode')}');
      stockfullnamelist.add('${object.get('StockFullName')}');
    }

    List<SalesDataModel> salesDataList = [];

    print(datelist);

    for (int i = 0; i < datelist.length; i++) {
      SalesDataModel model = SalesDataModel(
        date: datelist[i],
        invoice: invoicelist[i],
        quantity: quantitylist[i],
        unitprice: unitpricelist[i],
        stockcode: stockcodelist[i],
        stockfullname: stockfullnamelist[i],
        debtor: debtor,
      );
      salesDataList.add(model);
    }

    //sort the data in descending order based on date
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    salesDataList.sort(
        (a, b) => dateFormat.parse(b.date).compareTo(dateFormat.parse(a.date)));

    return salesDataList;
  } else {
    return [];
  }
}
