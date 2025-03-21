import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:telecell_price_history_checker/constants/secrets.dart';
import '../models/debtor_list_model.dart';

Future<List<DebtorListModel>> getDebtorList() async {
  const keyApplicationId = Secret.keyApplicationId;
  const keyClientKey = Secret.keyClientKey;
  const keyParseServerUrl = Secret.keyParseServerUrl;

  List<String> debtorlist = [];

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, debug: true);

  final QueryBuilder<ParseObject> parseQuery =
      QueryBuilder<ParseObject>(ParseObject('Debtorname'));

  parseQuery.setLimit(1500);

  final apiResponse = await parseQuery.query();

  if (apiResponse.success && apiResponse.results != null) {
    for (var o in apiResponse.results as List<ParseObject>) {
      debtorlist.add('${o.get('A')}');
    }
    List<DebtorListModel> debtorModels = debtorlist.map((debtor) {
      return DebtorListModel(debtor: debtor);
    }).toList();
    return debtorModels;
  } else {
    return [];
  }
}
