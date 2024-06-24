import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petfinder_user/models/pet_model.dart';
import 'package:petfinder_user/providers/pets_provider.dart';

import '../services/assets_manager.dart';
import '../widgets/pets/pet_widget.dart';
import '../widgets/title_text.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<PetModel> petListSearch = [];
  @override
  Widget build(BuildContext context) {
    final petsProvider = Provider.of<PetsProvider>(context, listen: false);
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    List<PetModel> petList = passedCategory == null
        ? petsProvider.pets
        : petsProvider.findByCategory(categoryName: passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AssetsManager.paws,
            ),
          ),
          title: TitlesTextWidget(label: passedCategory ?? "Search pets"),
        ),
        body: petList.isEmpty
            ? const Center(child: TitlesTextWidget(label: "No pet found"))
            : StreamBuilder<List<PetModel>>(
                stream: petsProvider.fetchPetsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(snapshot.error.toString()),
                    );
                  } else if (snapshot.data == null) {
                    return const Center(
                      child: SelectableText("No pets has been added"),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextField(
                          controller: searchTextController,
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // setState(() {
                                FocusScope.of(context).unfocus();
                                searchTextController.clear();
                                // });
                              },
                              child: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          // onChanged: (value) {
                          //   setState(() {
                          //     petListSearch = petsProvider.searchQuery(
                          //         searchText: searchTextController.text);
                          //   });
                          // },
                          onSubmitted: (value) {
                            setState(() {
                              petListSearch = petsProvider.searchQuery(
                                  searchText: searchTextController.text,
                                  passedList: petList);
                            });
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        if (searchTextController.text.isNotEmpty &&
                            petListSearch.isEmpty) ...[
                          const Center(
                            child: TitlesTextWidget(label: "No pets found"),
                          ),
                        ],
                        Expanded(
                          child: DynamicHeightGridView(
                            itemCount: searchTextController.text.isNotEmpty
                                ? petListSearch.length
                                : petList.length,
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            builder: (context, index) {
                              return PetWidget(
                                petId: searchTextController.text.isNotEmpty
                                    ? petListSearch[index].petId
                                    : petList[index].petId,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
