import 'package:shoeshop/models/productt.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() async {
    final productsCollection = FirebaseFirestore.instance.collection('Products');
    final snapshot = await productsCollection.get();
    final productsList = snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
    products.assignAll(productsList);
  }
}
