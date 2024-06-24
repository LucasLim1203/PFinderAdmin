import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petfinder_user/widgets/title_text.dart';

import '../../providers/pets_provider.dart';
import '../../widgets/app_name_text.dart';
import '../../widgets/pets/heart_btn.dart';
import '../../widgets/subtitle_text.dart';

class PetDetailsScreen extends StatefulWidget {
  static const routName = "/PetDetailsScreen";
  const PetDetailsScreen({super.key});

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final petsProvider = Provider.of<PetsProvider>(context);
    String? petId = ModalRoute.of(context)!.settings.arguments as String?;
    final getCurrPet = petsProvider.findByPetId(petId!);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // Navigator.canPop(context) ? Navigator.pop(context) : null;
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
          ),
        ),
        // automaticallyImplyLeading: false,
        title: const AppNameTextWidget(fontSize: 20),
      ),
      body: getCurrPet == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Column(
                children: [
                  FancyShimmerImage(
                    imageUrl: getCurrPet.petImage,
                    height: size.height * 0.38,
                    width: double.infinity,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                getCurrPet.petTitle,
                                softWrap: true,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            SubtitleTextWidget(
                              label: "Type : ${getCurrPet.petLostnfound}",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HeartButtonWidget(
                                bkgColor: Colors.blue.shade100,
                                petId: getCurrPet.petId,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitlesTextWidget(label: "Description"),
                            SubtitleTextWidget(
                              label: "Category In: ${getCurrPet.petCategory}",
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TitlesTextWidget(
                          label: "USERNAME : ${getCurrPet.petFname}",
                        ),
                        TitlesTextWidget(
                          label: "PHONE NUMBER : ${getCurrPet.petPhone}",
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SubtitleTextWidget(
                          label: getCurrPet.petDescription,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
