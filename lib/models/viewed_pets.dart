import 'package:flutter/material.dart';

class ViewedPetModel with ChangeNotifier {
  final String viewedPetId;
  final String petId;

  ViewedPetModel({
    required this.viewedPetId,
    required this.petId,
  });
}
