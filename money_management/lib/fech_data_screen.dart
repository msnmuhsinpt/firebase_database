import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  String ddTotal = "";
  String ddBalance = "";

  Query dbRef = FirebaseDatabase.instance.ref().child('Money Management');

  @override
  void initState() {
    super.initState();

    setState(() {
      grandBalance();
      grandTotal();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Name',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  'Price',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  'Qty',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  'Amount',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  'Debit',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: FirebaseAnimatedList(
              query: dbRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map data = snapshot.value as Map;
                data['key'] = snapshot.key;
                return listItem(data);
              },
            ),
          ),
          SizedBox(
            height: 50,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Grand Total:  ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      Text(
                        ddTotal,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Grant Balance:  ',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      Text(
                        ddBalance,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  void grandTotal() {
    DatabaseReference dTotal =
        FirebaseDatabase.instance.ref('Money Management/Grand totalAmount');
    dTotal.ref.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data == Null) {
        ddTotal = '0';
      } else {
        //gTotal = gdTotal.toString() as DatabaseReference
        ddTotal = data.toString();
      }
    });
  }

  void grandBalance() {
    DatabaseReference dBalance =
        FirebaseDatabase.instance.ref('Money Management/Grand Balance');
    dBalance.ref.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data == null) {
        ddBalance = '0';
      } else {
        ddBalance = data.toString();
      }
    });
  }

  Widget listItem(Map data) {
    return data.isEmpty
        ? const Center(
            child: Text(
              'Is Empty',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['productName'],
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.black),
                ),
                Text(
                  data['productPrice'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  data['qty'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  data['Total Amount'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  data['Debit Amount'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          );
  }
}
