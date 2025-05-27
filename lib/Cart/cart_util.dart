import 'package:mongoappv2/Screens/MenuItemDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//import 'package:mongoappv2/MenuItem.dart'; // Import your MenuItem model

void persistCartItems(List<MenuItem> cartItems) async {
  final prefs = await SharedPreferences.getInstance();

  final quantityMap = <String, int>{};
  for (var item in cartItems) {
    if (!quantityMap.containsKey(item.name)) {
      quantityMap[item.name] = 0;
    }
    quantityMap[item.name] = quantityMap[item.name]! + 1;
  }

  final updatedCartItems = <MenuItem>[];
  for (var item in cartItems) {
    final existingItemIndex =
        updatedCartItems.indexWhere((i) => i.name == item.name);

    if (existingItemIndex != -1) {
      // If the item already exists, update its quantity
      updatedCartItems[existingItemIndex].quantity += quantityMap[item.name]!;
    } else {
      // If the item does not exist, add a new item
      updatedCartItems.add(MenuItem(
        name: item.name,
        price: item.price,
        quantity: quantityMap[item.name]!,
        restaurantName: '',
        collectionName: '',
      ));
    }
  }

  final cartItemsJson =
      jsonEncode(updatedCartItems.map((item) => item.toJson()).toList());
  prefs.setString('cartItems', cartItemsJson);
}

Future<List<MenuItem>> loadCartItems() async {
  final prefs = await SharedPreferences.getInstance();
  final cartItemsJson = prefs.getString('cartItems');
  if (cartItemsJson != null) {
    final cartItemsList = jsonDecode(cartItemsJson) as List;
    return cartItemsList.map((item) => MenuItem.fromJson(item)).toList();
  } else {
    return [];
  }
}
