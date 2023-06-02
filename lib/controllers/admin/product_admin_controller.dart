import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/models/product.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductAdminController extends GetxController {
  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() async {
    final productsCollection = FirebaseFirestore.instance.collection('Products');
    final snapshot = await productsCollection.orderBy('id').get();
    final productsList = snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
    products.assignAll(productsList);
  }

  void addProduct(Product product) async {
    final productsCollection = FirebaseFirestore.instance.collection('Products');
    final docRef = await productsCollection.add(product.toJson());
    products.add(product);
  }

  void editProduct(Product product) async {
    final productsCollection = FirebaseFirestore.instance.collection('Products');
    await productsCollection.doc(product.id).update(product.toJson());
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
    }
  }

  void deleteProduct(String productId) async {
    final productsCollection = FirebaseFirestore.instance.collection('Products');
    final querySnapshot = await productsCollection.where('id', isEqualTo: productId).get();
    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;
      await productsCollection.doc(docId).delete();
      products.removeWhere((p) => p.id == productId);
    } else {
      print('Product not found');
    }
  }


}
