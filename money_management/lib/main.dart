import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_management/list_screen.dart';
import 'package:money_management/product_model.dart';

import 'client_list_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController qtyController = TextEditingController();
  final fb = FirebaseDatabase.instance.ref("Money Management");

  //client
  List<ClientList> clientList = [];
  ClientList selectedClient = ClientList("", "");

  //product
  List<ProductModel> productList = [];
  ProductModel selectedProduct = ProductModel("", "", 00.00);

  double total = 00.00;
  String qty = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      //client
      clientList.clear();
      clientList.add(ClientList("001", "Mattil Mall"));
      clientList.add(ClientList("002", "Lulu Mall"));
      clientList.add(ClientList("003", "Focus Mall"));
      clientList.add(ClientList("004", "Highlight Mall"));
      clientList.add(ClientList("005", "Mithra Mall"));
      //product
      productList.clear();
      productList.add(ProductModel("120", "Furniture ", 1000.00));
      productList.add(ProductModel("125", "Toys", 500.00));
      productList.add(ProductModel("124", "Dress", 250.00));
      productList.add(ProductModel("150", "Food", 100.00));
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
                    child: DropdownButton<ClientList>(
                        isExpanded: true,
                        hint: const Text('Choose Client'),
                        value: selectedClient.clientName == ""
                            ? null
                            : selectedClient,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (data) {
                          setState(() {
                            selectedClient = data!;
                          });
                        },
                        items: clientList.map((ClientList value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value.clientName),
                          );
                        }).toList()),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                  )),
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
                  textInputAction: TextInputAction.done,
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
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  final ref = fb.child(selectedClient.clientId);
                  final msn = ref.child(selectedProduct.productId);

                  if (selectedClient.clientId == "") {
                    Fluttertoast.showToast(msg: "select client");
                  } else if (selectedProduct.productId == "") {
                    Fluttertoast.showToast(msg: "select Product");
                  } else if (qtyController.text == "") {
                    Fluttertoast.showToast(msg: "Fill qty");
                  } else {
                    qty = qtyController.text.toString();
                    total =
                        double.parse(selectedProduct.productPrice.toString())
                                .toDouble() *
                            double.parse(qty).toDouble();
                    if (selectedClient.clientId != selectedClient.clientId) {
                      ref.set({
                        "ClientName": selectedClient.clientName.toString(),
                        "ProductId": selectedProduct.productId.toString(),
                        "totalAmount": total.toString(),
                      });
                    }
                    msn.set({
                      "productName": selectedProduct.productName,
                      "productPrice": selectedProduct.productPrice,
                      "qty": qty.toString(),
                    });
                  }
                },
                child: const Text("Submit"),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ListScreen()),
                  );
                },
                child: const Text("go to details"))
          ],
        ),
      ),
    );
  }
}
