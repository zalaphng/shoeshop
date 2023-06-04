import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shoeshop/models/favourite.dart';

class FavouriteController {

  final favourites = RxList<String>([]);

  final CollectionReference _favouritesCollection =
  FirebaseFirestore.instance.collection('Favourites');

  Future<void> addFavourite(String userId, String productId) async {
    favourites.add(productId);

    final DocumentReference favouriteDocRef = _favouritesCollection.doc(userId);

    final DocumentSnapshot favouriteSnapshot = await favouriteDocRef.get();
    final List<String> currentProductIds =
    favouriteSnapshot.exists ? List.from(favouriteSnapshot.get('productIds') ?? []) : [];

    currentProductIds.add(productId);

    await favouriteDocRef.set(Favourite(userId: userId, productIds: currentProductIds).toJson());
  }

  Future<void> removeFavourite(String userId, String productId) async {
    favourites.remove(productId);

    final DocumentReference favouriteDocRef = _favouritesCollection.doc(userId);

    final DocumentSnapshot favouriteSnapshot = await favouriteDocRef.get();
    final List<String> currentProductIds =
    favouriteSnapshot.exists ? List.from(favouriteSnapshot.get('productIds') ?? []) : [];

    currentProductIds.remove(productId);

    await favouriteDocRef.set(Favourite(userId: userId, productIds: currentProductIds).toJson());
  }

  // Future<List<String>> getFavorites(String userId) async {
  //   final DocumentReference favouriteDocRef =
  //   _favouritesCollection.doc(userId);
  //
  //   final DocumentSnapshot favouriteSnapshot = await favouriteDocRef.get();
  //   final List<String> currentProductIds =
  //   favouriteSnapshot.exists ? List.from(favouriteSnapshot.get('productIds') ?? []) : [];
  //
  //   return currentProductIds;
  // }

  Stream<List<String>> getFavourites(String userId) {
    final DocumentReference favouriteDocRef = _favouritesCollection.doc(userId);

    return favouriteDocRef.snapshots().map((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        final List<String> currentProductIds =
        List.from(documentSnapshot.get('productIds') ?? []);
        return currentProductIds;
      } else {
        return [];
      }
    });
  }

  Future<bool> isFavourite(String userId, String productId) async {
    final DocumentReference favouriteDocRef = _favouritesCollection.doc(userId);

    final DocumentSnapshot favouriteSnapshot = await favouriteDocRef.get();
    final List<String> currentProductIds = favouriteSnapshot.exists
        ? List.from(favouriteSnapshot.get('productIds') ?? [])
        : [];

    return currentProductIds.contains(productId);
  }


}