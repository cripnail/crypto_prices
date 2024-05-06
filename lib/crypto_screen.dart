import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'api_service.dart';

class CryptoScreen extends StatefulWidget {
  const CryptoScreen({super.key});

  @override
  CryptoScreenState createState() => CryptoScreenState();
}

class CryptoScreenState extends State<CryptoScreen> {
  final ApiService _apiService = ApiService();
  final List<dynamic> _cryptos = [];
  bool _isLoading = false;
  int _currentPage = 0;
  final _numberFormatter = NumberFormat("#,##0.00", "en_US");

  Color _randomPastelColor() {
    Random random = Random();
    return Color.fromRGBO(
      127 + random.nextInt(128),
      127 + random.nextInt(128),
      127 + random.nextInt(128),
      0.25,
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    setState(() => _isLoading = true);
    List<dynamic> newCryptos =
        await _apiService.fetchCryptos(start: _currentPage * 15);
    setState(() {
      _cryptos.addAll(newCryptos);
      _currentPage++;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchData();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _cryptos.length,
          itemBuilder: (context, index) {
            return Container(
              width: 375,
              height: 84,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _randomPastelColor(),
                      borderRadius: BorderRadius.circular(14.9),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      _cryptos[index]['symbol'].toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    width: 91,
                    alignment: Alignment.centerRight,
                    child: Text(
                      '\$ ${_numberFormatter.format(double.parse(_cryptos[index]['priceUsd']))}',
                      style: const TextStyle(
                        fontFamily: 'SF Pro Text',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.41,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
