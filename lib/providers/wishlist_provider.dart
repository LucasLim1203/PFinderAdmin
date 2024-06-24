import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:petfinder_user/models/wishlist_model.dart';
import 'package:uuid/uuid.dart';

import '../services/my_app_functions.dart';

class WishlistProvider with ChangeNotifier {
  final Map<String, WishlistModel> _wishlistItems = {};
  Map<String, WishlistModel> get getWishlists {
    return _wishlistItems;
  }

  final userstDb = FirebaseFirestore.instance.collection("users");
  final _auth = FirebaseAuth.instance;
// Firebase
  Future<void> addToWishlistFirebase({
    required String petId,
    required BuildContext context,
  }) async {
    final User? user = _auth.currentUser;
    if (user == null) {
      MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "Please login first",
        fct: () {},
      );
      return;
    }
    final uid = user.uid;
    final wishlistId = const Uuid().v4();
    try {
      await userstDb.doc(uid).update({
        'userWish': FieldValue.arrayUnion([
          {
            'wishlistId': wishlistId,
            'petId': petId,
          }
        ])
      });

      Fluttertoast.showToast(msg: "Pet has been added");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchWishlist() async {
    final User? user = _auth.currentUser;
    if (user == null) {
      _wishlistItems.clear();
      return;
    }
    try {
      final userDoc = await userstDb.doc(user.uid).get();
      final data = userDoc.data();
      if (data == null || !data.containsKey('userWish')) {
        return;
      }
      final leng = userDoc.get("userWish").length;
      for (int index = 0; index < leng; index++) {
        _wishlistItems.putIfAbsent(
            userDoc.get("userWish")[index]['petId'],
            () => WishlistModel(
                  wishlistId: userDoc.get("userWish")[index]['wishlistId'],
                  petId: userDoc.get("userWish")[index]['petId'],
                ));
      }
    } catch (e) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> removeWishlistItemFromFirestore({
    required String wishlistId,
    required String petId,
  }) async {
    final User? user = _auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userWish': FieldValue.arrayRemove([
          {
            'wishlistId': wishlistId,
            'petId': petId,
          }
        ])
      });
      _wishlistItems.remove(petId);
      Fluttertoast.showToast(msg: "Pet has been removed");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearWishlistFromFirebase() async {
    final User? user = _auth.currentUser;
    try {
      await userstDb.doc(user!.uid).update({
        'userWish': [],
      });
      _wishlistItems.clear();
      Fluttertoast.showToast(msg: "Wishlist has been cleared");
    } catch (e) {
      rethrow;
    }
  }

// Local
  void addOrRemoveFromWishlist({required String petId}) {
    if (_wishlistItems.containsKey(petId)) {
      _wishlistItems.remove(petId);
    } else {
      _wishlistItems.putIfAbsent(
        petId,
        () => WishlistModel(wishlistId: const Uuid().v4(), petId: petId),
      );
    }

    notifyListeners();
  }

  bool isProdinWishlist({required String petId}) {
    return _wishlistItems.containsKey(petId);
  }

  void clearLocalWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }
}
