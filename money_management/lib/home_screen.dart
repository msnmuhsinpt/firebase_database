import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_management/product_list_model.dart';
import 'client_list_model.dart';
import 'fech_data_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController qtyController = TextEditingController();
  TextEditingController addAmountController = TextEditingController();

  //client
  List<ClientList> clientList = [];
  ClientList selectedClient = ClientList("", "");

  //product
  List<ProductModel> productList = [];
  ProductModel selectedProduct = ProductModel("", "", 00.00);

  bool isOnes = false;
  double dbTotal = 0.00;
  double total = 00.00;
  String qty = "";
  double balance = 0.00;
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Money Management');

    setState(() {
      isOnes = false;
      readData();
      //product
      productList.clear();
      productList.add(ProductModel("120", "Furniture ", 1000.00));
      productList.add(ProductModel("125", "Toys", 500.00));
      productList.add(ProductModel("124", "Dress", 250.00));
      productList.add(ProductModel("150", "Food", 100.00));
    });
    dbRef.set({
      "Grand Balance": balance.toString(),
      "Grand totalAmount": total.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 55,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ProductModel>(
                        isExpanded: true,
                        hint: const Text('Choose product'),
                        value: selectedProduct.productName == ""
                            ? null
                            : selectedProduct,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (data) {
                          setState(() {
                            selectedProduct = data!;
                          });
                        },
                        items: productList.map((ProductModel value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.productName),
                          );
                        }).toList()),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Text('Product Price: ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    Text(
                      "${selectedProduct.productPrice}",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 55,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(width: 1),
                ),
                child: TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      border: InputBorder.none,
                      hintText: 'How Many Qty'),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 55,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: const BorderSide(width: 1),
                ),
                child: TextField(
                  controller: addAmountController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      border: InputBorder.none,
                      hintText: 'add amount'),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedProduct.productId == "") {
                    Fluttertoast.showToast(msg: "select Product");
                  } else if (qtyController.text == "") {
                    Fluttertoast.showToast(msg: "Fill qty");
                  } else {
                    qty = qtyController.text.toString();
                    total = double.parse(dbTotal.toString()).toDouble() +
                        double.parse(selectedProduct.productPrice.toString())
                                .toDouble() *
                            double.parse(qty).toDouble();
                    balance = (total -
                            double.parse(addAmountController.text.toString()))
                        .toDouble();

                    dbRef.update({
                      "Grand Balance": balance.toString(),
                      "Grand totalAmount": total.toString(),
                    });
                    Map<String, String> newOrder = {
                      "productName": selectedProduct.productName.toString(),
                      "productPrice": selectedProduct.productPrice.toString(),
                      "qty": qty.toString(),
                      "Total Amount": total.toString(),
                      "Debit Amount": addAmountController.text.toString()
                    };
                    dbRef.push().set(newOrder);
                  }
                },
                child: const Text("Submit"),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FetchData()),
                  );
                },
                child: const Text("go to details"))
          ],
        ),
      ),
    );
  }

  void readData() {
    DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('Money Management/totalAmount');
    starCountRef.ref.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data == null) {
        print('No Data');
      } else {
        dbTotal = double.parse(data.toString());
      }

      //log("dBData>>>>   $dbTotal");
    });
  }
}
