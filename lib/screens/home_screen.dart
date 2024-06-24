import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petfinder_user/consts/app_constants.dart';
import 'package:petfinder_user/widgets/pets/ctg_rounded_widget.dart';
import 'package:petfinder_user/widgets/pets/latest_arrival.dart';

import '../providers/pets_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/app_name_text.dart';
import '../widgets/title_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final petsProvider = Provider.of<PetsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            AssetsManager.paws,
          ),
        ),
        title: const AppNameTextWidget(fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: petsProvider.getPets.isNotEmpty,
                child: const TitlesTextWidget(label: "New Pets"),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: petsProvider.getPets.isNotEmpty,
                child: SizedBox(
                  height: size.height * 0.2,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: petsProvider.getPets.length < 10
                          ? petsProvider.getPets.length
                          : 10,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: petsProvider.getPets[index],
                            child: const LatestArrivalPetsWidget());
                      }),
                ),
              ),
              const TitlesTextWidget(label: "Categories"),
              const SizedBox(
                height: 15.0,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children:
                    List.generate(AppConstants.categoriesList.length, (index) {
                  return CategoryRoundedWidget(
                    image: AppConstants.categoriesList[index].image,
                    name: AppConstants.categoriesList[index].name,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
