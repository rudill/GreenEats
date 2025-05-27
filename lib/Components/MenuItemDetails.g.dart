// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../Screens/MenuItemDetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItem _$MenuItemFromJson(Map<String, dynamic> json) => MenuItem(
      name: json['name'] as String,
      price: json['price'] != null
          ? (json['price'] as num).toInt()
          : 0, // default value is 0
      quantity:
          json['quantity'] != null ? (json['quantity'] as num).toInt() : 0,
      restaurantName: '',
      collectionName: '', // default value is 0
    );

Map<String, dynamic> _$MenuItemToJson(MenuItem instance) => <String, dynamic>{
      'collectionName': instance.collectionName,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
    };
