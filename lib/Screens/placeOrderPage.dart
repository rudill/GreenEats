// import 'dart:html';

//import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mongoappv2/Cart/Cart.dart';
import 'package:mongoappv2/Screens/MenuItemDetails.dart';
import 'package:http/http.dart' as http;
import 'package:mongoappv2/main.dart';
import 'package:mongoappv2/Components/orderStatus.dart';
//import 'package:provider/provider.dart';
//import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import '../Notification/Notifications.dart';
//import 'package:web_socket_channel/io.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';

//import 'package:web_socket_channel/web_socket_channel.dart';
//import 'main.dart';

class PlaceOrderPage extends StatefulWidget {
  final List<MenuItem> items;
  final String restaurantName;

  const PlaceOrderPage({
    super.key,
    required this.items,
    required this.restaurantName,
  });

  @override
  State<PlaceOrderPage> createState() => _PlaceOrderPageState();
}

class _PlaceOrderPageState extends State<PlaceOrderPage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  String? fcmToken;

  @override
  void initState() {
    super.initState();

    messaging.getToken().then((String? token) {
      assert(token != null);
      print('FCM Token: $token');
      setState(() {
        fcmToken = token;
      });
      // You can now send this token to your server or save it for later use
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  // @override
  // void initState() {
  //   super.initState();
  //   channel = IOWebSocketChannel.connect('ws://your-server.com:8080');

  //   channel.stream.listen((message) {
  //     // Handle incoming messages from the server
  //     var responseData = jsonDecode(message);
  //     if (responseData['status'] == 'received') {
  //       // Show a notification or update the UI to reflect that the order was received
  //       print('Order received');
  //     } else {
  //       // Handle other statuses
  //       print('Order not received');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // final orderStatusProvider =
    //     Provider.of<OrderStatusProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Order'),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: _isProcessing
          ? Center(
              child: Image.asset(
                'images/loader.gif',
                height: 300.0, // You can adjust as needed.
                width: 300.0, // You can adjust as needed.
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Green',
                                      style: TextStyle(
                                        color: Color(0xFF00B860),
                                        fontSize: 32,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w900,
                                        height: 0,
                                        letterSpacing: -2.24,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Eats',
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 32,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w900,
                                        height: 0,
                                        letterSpacing: -2.24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 307,
                                    height: 100.58,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: nameController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Enter your full name',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your full name';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 307,
                                    height: 100.58,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: phoneController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText:
                                                'Enter your phone number',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your phone number';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 307,
                                    height: 100.58,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: idController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Enter your student ID',
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter your student ID';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00B860),
                                  ),
                                  child: const Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    for (var i = 0;
                                        i < widget.items.length;
                                        i++) {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isProcessing = true;
                                        });
                                        // If the form is valid, display a snackbar. In the real world,
                                        // you'd often call a server or save the information in a database.
                                        // ignore: use_build_context_synchronously
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(
                                        //   const SnackBar(
                                        //       content: Text('Processing Data')),
                                        // );

                                        Uri url = Uri.parse(
                                            'https://mernback1-n2ty.onrender.com/profile1/orders1');
                                        if (widget.restaurantName ==
                                            'Hostel Canteen') {
                                          url = Uri.parse(
                                              'https://mernback1-n2ty.onrender.com/profile1/orders');
                                        }
                                        if (widget.restaurantName ==
                                            'Auditorium Canteen') {
                                          url = Uri.parse(
                                              'https://mernback1-n2ty.onrender.com/profile2/orders');
                                        }
                                        if (widget.restaurantName ==
                                            'Finagle') {
                                          url = Uri.parse(
                                              'https://mernback1-n2ty.onrender.com/profile3/orders');
                                        }
                                        if (widget.restaurantName ==
                                            'Ayu\'s cafe') {
                                          url = Uri.parse(
                                              'https://mernback1-n2ty.onrender.com/profile4/orders');
                                        }
                                        if (widget.restaurantName ==
                                            'So cafe') {
                                          url = Uri.parse(
                                              'https://mernback1-n2ty.onrender.com/profile5/orders');
                                        }
                                        if (widget.restaurantName ==
                                            'Hela bojun') {
                                          url = Uri.parse(
                                              'https://mernback1-n2ty.onrender.com/profile6/orders');
                                        }
                                        if (widget.restaurantName ==
                                            'Juice bar') {
                                          url = Uri.parse(
                                              'https://mernback1-n2ty.onrender.com/profile7/orders');
                                        }

                                        final response = await http.post(
                                          // Uri.parse(
                                          //     'https://mernback1-n2ty.onrender.com/profile1/orders'),
                                          url,
                                          headers: <String, String>{
                                            'Content-Type':
                                                'application/json; charset=UTF-8',
                                          },
                                          body: jsonEncode(
                                            {
                                              'items': widget.items
                                                  .map((item) => item.toJson())
                                                  .toList(),
                                              'price': widget.items.fold(
                                                  0,
                                                  (total, item) =>
                                                      total +
                                                      item.price *
                                                          item.quantity),
                                              'name': nameController.text,
                                              'phone': phoneController.text,
                                              'id': idController.text,
                                              'token': fcmToken,
                                            },
                                          ),
                                        );
                                        setState(() {
                                          _isProcessing = false;
                                        });

                                        // if (response.statusCode == 200) {
                                        //   // If the server returns a 200 OK response,
                                        //   // then parse the JSON.
                                        //   print('Order placed successfully');
                                        //   Notifications.showNotification(
                                        //       title: 'Order Placed',
                                        //       body:
                                        //           'Your order has been placed');
                                        //   //auto remove from cart
                                        // }
                                        if (response.statusCode == 200) {
                                          var responseData =
                                              jsonDecode(response.body);

                                          if (responseData['status'] ==
                                              'received') {
                                            print(
                                                'Order received successfully');
                                            Notifications.showNotification(
                                                title: 'Order received',
                                                body:
                                                    'Your order has been received');

                                            orderStatus.dispatch(
                                                UpdateOrderStatusAction(
                                                    'received'));

                                            // orderStatusProvider
                                            //     .updateStatus('Order received');

                                            // notifyFlutter('order_accepted',
                                            //     idController.text);
                                            // await notifyFlutter();
                                          } else {
                                            print('Order not received');
                                            Notifications.showNotification(
                                                title: 'Order not received',
                                                body:
                                                    'Your order has not been received.Please try again');
                                            // orderStatusProvider.updateStatus(
                                            //     'No ongoing order');
                                          }
                                        } else {
                                          // If the server returns an unexpected response,
                                          // then throw an exception.
                                          print(
                                              'Failed to place order. Status code: ${response.statusCode}');
                                          Notifications.showNotification(
                                              title: 'Order not received',
                                              body:
                                                  'Your order has not been received.Please try again');
                                          print(
                                              'Response body: ${response.body}');
                                          throw Exception(
                                              'Failed to place order');
                                        }
                                        // ignore: use_build_context_synchronously
                                        await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Order received'),
                                            content: const Text(
                                                'Your order has been received'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamedAndRemoveUntil(
                                                      context,
                                                      '/home',
                                                      (route) =>
                                                          false); // Go back to the previous page
                                                },
                                                child:
                                                    const Text('Browse more'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      //Navigator.pop(context);

                                      // server call to place order
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00B860),
                                  ),
                                  child: const Text('Place Order'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Column(
                    children: [
                      // ListView.builder(
                      //   shrinkWrap: true,
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   itemCount: widget.items.length,
                      //   itemBuilder: (context, index) {
                      //     final item = widget.items[index];
                      //     final price = item.price;
                      //     final quantity = item.quantity;
                      //     return Center(
                      //       child: Text(
                      //         'Your Total Price is \Rs:${price * quantity}',
                      //         style: const TextStyle(
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 24.0,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 50,
                          decoration: const ShapeDecoration(
                            color: Color.fromARGB(255, 0, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Total price: LKR ${widget.items.fold(0, (total, item) => total + item.price * item.quantity)}.00',
                              style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 25,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    idController.dispose();
    super.dispose();
  }
}
