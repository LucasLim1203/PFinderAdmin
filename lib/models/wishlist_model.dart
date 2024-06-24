import 'package:flutter/material.dart';

class WishlistModel with ChangeNotifier {
  final String wishlistId;
  final String petId;

  WishlistModel({
    required this.wishlistId,
    required this.petId,
  });
}
