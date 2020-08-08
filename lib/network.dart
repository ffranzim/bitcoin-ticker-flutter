import 'dart:convert';

import 'package:http/http.dart' as http;

class Network {
  final kUrlBase = 'https://rest.coinapi.io/v1/exchangerate';

  final Map<String, String> kHeaders = {
    'X-CoinAPI-Key': 'AEA854D0-4A28-4E1E-B127-7AA37F7FE460'
  };

//  https://rest.coinapi.io/v1/exchangerate/USD/ETH

  Future<dynamic> fetchCoin(
      String selectedCoin, String selectedCurrency) async {
    print(kUrlBase);
    http.Response response = await http
        .get('$kUrlBase/$selectedCoin/$selectedCurrency', headers: kHeaders);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }

  Future<dynamic> fetchCoinsForCurrency(String selectedCurrency) async {
    print(kUrlBase);
    http.Response response =
        await http.get('$kUrlBase/$selectedCurrency', headers: kHeaders);
    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}
