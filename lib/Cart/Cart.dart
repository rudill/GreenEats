//import 'package:flutter/material.dart';
import 'package:mongoappv2/Screens/MenuItemDetails.dart';
import 'package:mongoappv2/Cart/cart_util.dart';
import 'package:redux/redux.dart';
//import 'package:flutter_redux/flutter_redux.dart';

class AppState {
  final Map<String, List<MenuItem>> cartItems;

  AppState({required this.cartItems});

  int get totalPrice => cartItems.values
      .expand((x) => x)
      .fold(0, (total, current) => total + current.price * current.quantity);
}

class AddItemAction {
  final MenuItem item;
  final String restaurant;

  AddItemAction({required this.item, required this.restaurant});
}

class RemoveItemAction {
  final MenuItem item;
  final String restaurant;

  RemoveItemAction({required this.item, required this.restaurant});
}

AppState appReducer(AppState state, dynamic action) {
  if (action is AddItemAction) {
    final restaurant = action.restaurant;
    final item = action.item;
    if (state.cartItems.containsKey(restaurant)) {
      state.cartItems[restaurant]!.add(item);
    } else {
      state.cartItems[restaurant] = [item];
    }
  } else if (action is RemoveItemAction) {
    final restaurant = action.restaurant;
    final item = action.item;
    state.cartItems[restaurant]!.remove(item);
    if (state.cartItems[restaurant]!.isEmpty) {
      state.cartItems.remove(restaurant);
    }
  }
  return state;
}

void cartItemsMiddleware(Store<AppState> store, action, NextDispatcher next) {
  next(action);

  if (action is AddItemAction || action is RemoveItemAction) {
    persistCartItems(store.state.cartItems.values.expand((x) => x).toList());
  }
}

final store = Store<AppState>(appReducer,
    initialState: AppState(cartItems: {}), middleware: [cartItemsMiddleware]);
