import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/pet_model.dart';

class PetsProvider with ChangeNotifier {
  List<PetModel> pets = [];
  List<PetModel> get getPets {
    return pets;
  }

  PetModel? findByPetId(String petId) {
    if (pets.where((element) => element.petId == petId).isEmpty) {
      return null;
    }
    return pets.firstWhere((element) => element.petId == petId);
  }

  List<PetModel> findByCategory({required String categoryName}) {
    List<PetModel> categoryList = pets
        .where(
          (element) => element.petCategory.toLowerCase().contains(
                categoryName.toLowerCase(),
              ),
        )
        .toList();
    return categoryList;
  }

  List<PetModel> searchQuery(
      {required String searchText, required List<PetModel> passedList}) {
    List<PetModel> searchList = passedList
        .where(
          (element) => element.petTitle.toLowerCase().contains(
                searchText.toLowerCase(),
              ),
        )
        .toList();
    return searchList;
  }

  final petDb = FirebaseFirestore.instance.collection("pets");
  Future<List<PetModel>> fetchPets() async {
    try {
      await petDb
          .orderBy('createdAt', descending: false)
          .get()
          .then((petSnapshot) {
        pets.clear();
        // pets = []
        for (var element in petSnapshot.docs) {
          pets.insert(0, PetModel.fromFirestore(element));
        }
      });
      notifyListeners();
      return pets;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<PetModel>> fetchPetsStream() {
    try {
      return petDb.snapshots().map((snapshot) {
        pets.clear();
        // pets = []
        for (var element in snapshot.docs) {
          pets.insert(0, PetModel.fromFirestore(element));
        }
        return pets;
      });
    } catch (e) {
      rethrow;
    }
  }
}
