import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/user_controller.dart';

class FirebaseService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getNextOrderId() async {
    final user = _auth.currentUser;
    final docRef = firestore.doc('Counter/${user!.uid}');
    final result = await firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      final currentCount = snapshot.exists ? snapshot.data()!['count'] : 0;
      final nextCount = currentCount + 1;
      transaction.set(docRef, {'count': nextCount});
      return nextCount.toString().padLeft(5, '0');
    });
    return 'I$result';
  }

  Future<String> getNextProductId() async {
    final collectionRef = firestore.collection('Products');
    final querySnapshot = await collectionRef.orderBy('id', descending: true).limit(1).get();

    if (querySnapshot.docs.isNotEmpty) {
      final lastProduct = querySnapshot.docs.first;
      final currentId = lastProduct['id'];
      final currentIdNumber = int.parse(currentId.substring(1));
      final nextIdNumber = currentIdNumber + 1;
      final nextId = 'P${nextIdNumber.toString().padLeft(5, '0')}';
      return nextId;
    } else {
      return 'P00001';
    }
  }

  

}