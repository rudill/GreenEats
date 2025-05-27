import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class UpdateOrderStatusAction {
  final String status;

  UpdateOrderStatusAction(this.status);
}

String orderStatusReducer(String state, dynamic action) {
  if (action is UpdateOrderStatusAction) {
    return action.status;
  } else {
    return state;
  }
}

final orderStatus = Store<String>(orderStatusReducer, initialState: 'pending');

class OrderStatusWidget extends StatelessWidget {
  const OrderStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<String, String>(
      converter: (store) => store.state,
      builder: (context, status) {
        return Text('Order status: $status');
      },
    );
  }
}
