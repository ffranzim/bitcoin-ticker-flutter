import 'dart:convert';

import 'package:http/http.dart' as http;

const Map<String, String> kHeaders = {
  'X-CoinAPI-Key': 'AEA854D0-4A28-4E1E-B127-7AA37F7FE460'
};

const kUrlBase = 'https://rest.coinapi.io/v1/exchangerate/BTC/USD';

class Network {
  Future<dynamic> fetchCoin() async {
    http.Response response = await http.get(kUrlBase, headers: kHeaders);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
