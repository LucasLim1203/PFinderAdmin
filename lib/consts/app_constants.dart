import 'package:petfinder_user/models/categories_model.dart';
import 'package:flutter/material.dart';
import '../services/assets_manager.dart';

class AppConstants {
  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: "Dogs",
      image: AssetsManager.dog,
      name: "Dogs",
    ),
    CategoriesModel(
      id: "Cats",
      image: AssetsManager.cat,
      name: "Cats",
    ),
    CategoriesModel(
      id: "Others",
      image: AssetsManager.other,
      name: "Others",
    )
  ];

  static List<String> categoryList = [
    'Dogs',
    'Cats',
    'Others',
  ];
  static List<String> lostnfoundList = [
    'Found',
    'Lost',
    'Adopt',
  ];

  static List<DropdownMenuItem<String>>? get categoriesDropDownList {
    List<DropdownMenuItem<String>>? menuItems =
        List<DropdownMenuItem<String>>.generate(
      categoryList.length,
      (index) => DropdownMenuItem(
        value: categoryList[index],
        child: Text(
          categoryList[index],
        ),
      ),
    );
    return menuItems;
  }

  static List<DropdownMenuItem<String>>? get lostnfoundDropDownList {
    List<DropdownMenuItem<String>>? menuItems =
        List<DropdownMenuItem<String>>.generate(
      lostnfoundList.length,
      (index) => DropdownMenuItem(
        value: lostnfoundList[index],
        child: Text(
          lostnfoundList[index],
        ),
      ),
    );
    return menuItems;
  }
}
