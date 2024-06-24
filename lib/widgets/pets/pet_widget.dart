import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petfinder_user/screens/inner_screen/pet_details.dart';
import 'package:petfinder_user/widgets/subtitle_text.dart';
import 'package:petfinder_user/widgets/title_text.dart';

import '../../providers/pets_provider.dart';
import '../../providers/viewed_recently_provider.dart';
import 'heart_btn.dart';

class PetWidget extends StatefulWidget {
  const PetWidget({
    super.key,
    required this.petId,
  });
  final String petId;
  @override
  State<PetWidget> createState() => _PetWidgetState();
}

class _PetWidgetState extends State<PetWidget> {
  @override
  Widget build(BuildContext context) {
    // final petModelProvider = Provider.of<PetModel>(context);
    final petsProvider = Provider.of<PetsProvider>(context);
    final getCurrPet = petsProvider.findByPetId(widget.petId);
    Size size = MediaQuery.of(context).size;
    final viewedPetProvider = Provider.of<ViewedPetProvider>(context);

    return getCurrPet == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(0.0),
            child: GestureDetector(
              onTap: () async {
                viewedPetProvider.addViewedPet(petId: getCurrPet.petId);
                await Navigator.pushNamed(
                  context,
                  PetDetailsScreen.routName,
                  arguments: getCurrPet.petId,
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: FancyShimmerImage(
                      imageUrl: getCurrPet.petImage,
                      height: size.height * 0.22,
                      width: double.infinity,
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 5,
                          child: TitlesTextWidget(
                            label: getCurrPet.petTitle,
                            fontSize: 18,
                            maxLines: 2,
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: HeartButtonWidget(
                            petId: getCurrPet.petId,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: SubtitleTextWidget(
                            label: "${getCurrPet.petLostnfound}",
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
          );
  }
}
