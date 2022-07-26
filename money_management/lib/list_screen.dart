import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _fb = FirebaseDatabase.instance;
  String name = "";
  String expense = "";
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _dataListener();
  }

  void _dataListener() {
    _streamSubscription = _fb.ref('Money Management 2').onValue.listen((event) {
      final Map<Object?, dynamic> data = event.snapshot.value as Map;

      final String sName = data['Name'].toString();
      final String sExpense = data['Expense'].toString();
      setState(() {
        name = sName;
        expense = sExpense;
      });
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(name),
          const SizedBox(
            height: 10,
          ),
          Text(expense),
        ],
      ),
    ));
  }
}
