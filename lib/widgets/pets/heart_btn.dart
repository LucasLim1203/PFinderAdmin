import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:petfinder_user/providers/wishlist_provider.dart';

import '../../services/my_app_functions.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.bkgColor = Colors.transparent,
    this.size = 20,
    required this.petId,
    // this.isInWishlist = false,
  });
  final Color bkgColor;
  final double size;
  final String petId;
  // final bool? isInWishlist;
  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final wishlistsProvider = Provider.of<WishlistProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: widget.bkgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        style: IconButton.styleFrom(elevation: 10),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          try {
            // wishlistsProvider.addOrRemoveFromWishlist(
            //   petId: widget.petId,
            // );
            if (wishlistsProvider.getWishlists.containsKey(widget.petId)) {
              await wishlistsProvider.removeWishlistItemFromFirestore(
                wishlistId:
                    wishlistsProvider.getWishlists[widget.petId]!.wishlistId,
                petId: widget.petId,
              );
            } else {
              await wishlistsProvider.addToWishlistFirebase(
                petId: widget.petId,
                context: context,
              );
            }
            await wishlistsProvider.fetchWishlist();
          } catch (e) {
            await MyAppFunctions.showErrorOrWarningDialog(
              context: context,
              subtitle: e.toString(),
              fct: () {},
            );
          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },
        icon: _isLoading
            ? const CircularProgressIndicator()
            : Icon(
                wishlistsProvider.isProdinWishlist(
                  petId: widget.petId,
                )
                    ? IconlyBold.heart
                    : IconlyLight.heart,
                size: widget.size,
                color: wishlistsProvider.isProdinWishlist(
                  petId: widget.petId,
                )
                    ? Colors.red
                    : Colors.grey,
              ),
      ),
    );
  }
}
