//import 'package:flutter/cupertino.dart';
//import 'RestaurantMenu.dart';

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mongoappv2/Cart/Cart.dart';

import 'package:mongoappv2/Cart/cart_util.dart';
import 'package:mongoappv2/Models/userData.dart';
import 'package:redux/redux.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:vibration/vibration.dart';
import '../Notification/Notifications.dart';

part '../Components/MenuItemDetails.g.dart';

class MenuItemDetails extends StatelessWidget {
  final UserData menuItem;
  final String restaurantName;

  const MenuItemDetails(
      {super.key, required this.menuItem, required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, VoidCallback>(
      converter: (Store<AppState> store) {
        return () => store.dispatch(AddItemAction(
            item: MenuItem(
              name: menuItem.name,
              price: menuItem.price,
              quantity: 1,
              restaurantName: restaurantName,
              collectionName: '',
            ),
            restaurant: restaurantName));
      },
      builder: (BuildContext context, VoidCallback addToCart) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(menuItem.name),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 330,
                              height: 245,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  image: NetworkImage(menuItem.imgUrl),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 40.0, left: 20.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        menuItem.name,
                                        style: const TextStyle(
                                          color: Color(0xFF3F3D56),
                                          fontSize: 32,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 40.0, left: 20.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 161,
                                      height: 73,
                                      decoration: BoxDecoration(
                                          color: const Color(0xFF13A100),
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ]),
                                      child: Align(
                                        alignment:
                                            const AlignmentDirectional(0, 0),
                                        child: Text(
                                          'LKR ${menuItem.price.toStringAsFixed(2)}',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge, // Adjust this to your theme
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0, left: 20.0, right: 20.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  menuItem.description,
                                  style: const TextStyle(
                                    color: Color(0xFF3F3D56),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container()),
                AddToCart(menuItem: menuItem, restaurantName: restaurantName),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddToCart extends StatelessWidget {
  const AddToCart({
    required this.restaurantName,
    super.key,
    required this.menuItem,
  });

  final UserData menuItem;
  final String restaurantName;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Container(
          width: 350,
          height: 75,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 0, 0),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                color: const Color(0x3F000000),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  Vibration.vibrate(duration: 50);
                  int? quantity = await showDialog<int>(
                    context: context,
                    builder: (BuildContext context) {
                      int selectedQuantity = 1;

                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        title: const Text('Select quantity'),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('Quantity: $selectedQuantity'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(
                                          Icons.remove_circle_outlined),
                                      color: Colors.green,
                                      onPressed: selectedQuantity > 1
                                          ? () {
                                              setState(() {
                                                selectedQuantity--;
                                              });
                                            }
                                          : null,
                                    ),
                                    Text('$selectedQuantity'),
                                    IconButton(
                                      icon:
                                          const Icon(Icons.add_circle_outlined),
                                      color: Colors.green,
                                      onPressed: selectedQuantity < 10
                                          ? () {
                                              setState(() {
                                                selectedQuantity++;
                                              });
                                            }
                                          : null,
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(selectedQuantity);
                              Vibration.vibrate(duration: 50);
                              Notifications.showNotification(
                                  title: 'Added to cart',
                                  body:
                                      '${selectedQuantity}x ${menuItem.name} added to cart');
                            },
                          ),
                        ],
                      );
                    },
                  );

                  if (quantity != null) {
                    store.dispatch(AddItemAction(
                      item: MenuItem(
                        name: menuItem.name,
                        price: menuItem.price,
                        quantity: quantity,
                        restaurantName: restaurantName,
                        collectionName: '',
                      ),
                      restaurant: restaurantName,
                    ));
                    // for (int i = 0; i < quantity; i++) {
                    //   addToCart();
                    // }
                    // ignore: unnecessary_null_comparison
                    persistCartItems(store.state.cartItems != null
                        ? store.state.cartItems.values.expand((x) => x).toList()
                        : []);
                  }
                },
                child: const Center(
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@JsonSerializable()
class MenuItem {
  final String name;
  final String restaurantName;
  final int price;
  int quantity;
  final String collectionName;

  MenuItem({
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.restaurantName,
    required this.collectionName,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) =>
      _$MenuItemFromJson(json);
  Map<String, dynamic> toJson() => _$MenuItemToJson(this);

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is MenuItem &&
  //         runtimeType == other.runtimeType &&
  //         name == other.name;
  // @override
  // int get hashCode => name.hashCode;
}
