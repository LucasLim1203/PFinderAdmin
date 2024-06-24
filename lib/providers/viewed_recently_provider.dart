import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/viewed_pets.dart';

class ViewedPetProvider with ChangeNotifier {
  final Map<String, ViewedPetModel> _viewedPetItems = {};

  Map<String, ViewedPetModel> get getViewedPets {
    return _viewedPetItems;
  }

  void addViewedPet({required String petId}) {
    _viewedPetItems.putIfAbsent(
      petId,
      () => ViewedPetModel(viewedPetId: const Uuid().v4(), petId: petId),
    );

    notifyListeners();
  }
}
