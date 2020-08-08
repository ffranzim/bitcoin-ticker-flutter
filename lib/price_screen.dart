import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String valueSelectedCurrencyBTC = '?';
  String valueSelectedCurrencyETH = '?';
  String valueSelectedCurrencyLTC = '?';

  @override
  void initState() {
    super.initState();
//    getValueCoinCurrency();
    getValueCoinCurrencyOneRequest();
  }

  List<Text> getCupertinoPickerItems() {
    List<Text> pickerList = [];
    for (String currency in currenciesList) {
      pickerList.add(Text(currency));
    }

    return pickerList;
  }

  CupertinoPicker getCupertinoPicker() {
    return CupertinoPicker(
      itemExtent: 32.0,
      children: getCupertinoPickerItems(),
      onSelectedItemChanged: (selectIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectIndex];
//          getValueCoinCurrency();
          getValueCoinCurrencyOneRequest();
        });
      },
    );
  }

  List<DropdownMenuItem<String>> getDropdownItems() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];

      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }
    return dropdownItems;
  }

  DropdownButton<String> getAndroidDropdownButton() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: this.getDropdownItems(),
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getValueCoinCurrency();
//          getValueCoinCurrencyOneRequest();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildButton('BTC', valueSelectedCurrencyBTC, selectedCurrency),
              buildButton('ETH', valueSelectedCurrencyETH, selectedCurrency),
              buildButton('LTC', valueSelectedCurrencyLTC, selectedCurrency),
            ],
          ),
          Container(
            height: 80.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS
                ? getCupertinoPicker()
                : getAndroidDropdownButton(),
          ),
        ],
      ),
    );
  }

  Padding buildButton(String coin, String value, String currency) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.blue,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coin = $value $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getValueCoinCurrency() async {
    valueSelectedCurrencyBTC = '?';
    valueSelectedCurrencyETH = '?';
    valueSelectedCurrencyLTC = '?';

    var resultBTC = await Network().fetchCoin('BTC', selectedCurrency);
    var resultETH = await Network().fetchCoin('ETH', selectedCurrency);
    var resultLTC = await Network().fetchCoin('LTC', selectedCurrency);

    setState(() {
      double rateBTC = resultBTC['rate'];
      valueSelectedCurrencyBTC = rateBTC.toStringAsFixed(2).toString();

      double rateETH = resultETH['rate'];
      valueSelectedCurrencyETH = rateETH.toStringAsFixed(2).toString();

      double rateLTC = resultLTC['rate'];
      valueSelectedCurrencyLTC = rateLTC.toStringAsFixed(2).toString();
    });
  }

  Future<void> getValueCoinCurrencyOneRequest() async {
    valueSelectedCurrencyBTC = '?';
    valueSelectedCurrencyETH = '?';
    valueSelectedCurrencyLTC = '?';

    double valueBTC = 0.0;
    double valueETH = 0.0;
    double valueLTC = 0.0;

    var result = await Network().fetchCoinsForCurrency(selectedCurrency);

    List rates = result['rates'];

    rates.forEach((element) {
      if (element['asset_id_quote'] == 'BTC') {
        valueBTC = element['rate'];
      }
      if (element['asset_id_quote'] == 'ETH') {
        valueETH = element['rate'];
      }
      if (element['asset_id_quote'] == 'LTC') {
        valueLTC = element['rate'];
      }
    });

    print(valueBTC);

    setState(() {
      valueSelectedCurrencyBTC = valueBTC.toStringAsFixed(2).toString();
      valueSelectedCurrencyETH = valueETH.toStringAsFixed(2).toString();
      valueSelectedCurrencyLTC = valueLTC.toStringAsFixed(2).toString();
    });
  }
}
