import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petfinder_user/services/assets_manager.dart';
import 'package:petfinder_user/widgets/empty_bag.dart';
import 'package:petfinder_user/widgets/title_text.dart';

import '../../providers/viewed_recently_provider.dart';
import '../../widgets/pets/pet_widget.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  static const routName = "/ViewedRecentlyScreen";
  const ViewedRecentlyScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final viewedPetProvider = Provider.of<ViewedPetProvider>(context);

    return viewedPetProvider.getViewedPets.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.pending,
              title: "No viewed pets yet",
              subtitle: "Find out now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  AssetsManager.paws,
                ),
              ),
              title: TitlesTextWidget(
                  label:
                      "Viewed recently (${viewedPetProvider.getViewedPets.length})"),
            ),
            body: DynamicHeightGridView(
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              builder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PetWidget(
                      petId: viewedPetProvider.getViewedPets.values
                          .toList()[index]
                          .petId),
                );
              },
              itemCount: viewedPetProvider.getViewedPets.length,
              crossAxisCount: 2,
            ),
          );
  }
}
