import 'dart:io';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';

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
        });
      },
    );
  }

  getPicker() {
    if (Platform.isIOS) {
      return getCupertinoPicker();
    } else {
      return getAndroidDropdownButton();
    }
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
          Padding(
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
                  '1 BTC = ? $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
