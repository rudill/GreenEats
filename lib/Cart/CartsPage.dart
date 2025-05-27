import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mongoappv2/Cart/Cart.dart';
import 'package:mongoappv2/Screens/MenuItemDetails.dart';
import 'package:mongoappv2/Cart/cart_util.dart';
import 'package:mongoappv2/Screens/placeOrderPage.dart';
import 'package:vibration/vibration.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  int calculateTotalPrice(List<MenuItem> items) {
    int totalPrice = 0;
    for (var item in items) {
      totalPrice += item.price * item.quantity;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Map<String, List<MenuItem>>>(
      converter: (store) => store.state.cartItems,
      builder: (context, cartItems) {
        if (cartItems.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Carts'),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            body: const SafeArea(
              child: Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Image(image: AssetImage('images/emptycart.png'),),

                    Text(
                      'No items in the cart',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),
            ),

          );
        } else {
          return cartMethod(cartItems, context);
        }

        //cartMethod(cartItems, context);
      },
    );
  }

  Scaffold cartMethod(
      Map<String, List<MenuItem>> cartItems, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carts'),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Material(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: cartItems.entries.map((entry) {
                    final restaurantName = entry.key;
                    final items = entry.value;
                    final totalPrice = calculateTotalPrice(items);
                    return ExpansionTile(
                      collapsedIconColor: Colors.black,
                      initiallyExpanded: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            restaurantName,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 0, 0, 0)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlaceOrderPage(
                                    items: items,
                                    restaurantName: restaurantName,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Buy Now',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      children: items
                          .map(
                            (item) => ListTile(
                              title: Text(item.name),
                              subtitle: Text('Quantity: ${item.quantity}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_rounded),
                                iconSize: 30,
                                color: const Color.fromARGB(255, 42, 35, 35),
                                onPressed: () {
                                  store.dispatch(RemoveItemAction(
                                      item: item, restaurant: restaurantName));
                                  persistCartItems(store.state.cartItems.values
                                      .expand((x) => x)
                                      .toList());
                                  Vibration.vibrate(duration: 50);
                                },
                              ),
                            ),
                          )
                          .toList()
                        ..add(
                          ListTile(
                            title: Text(
                              'Total Price:                        LKR $totalPrice.00',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                height: 100,
                decoration: const ShapeDecoration(
                  color: Color.fromARGB(255, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
                child: Center(
                  child: StoreConnector<AppState, int>(
                    converter: (store) => store.state.totalPrice,
                    builder: (context, totalPrice) {
                      return Text(
                        'Total price: LKR $totalPrice.00',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 25,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
