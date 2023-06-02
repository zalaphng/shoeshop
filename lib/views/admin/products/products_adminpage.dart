import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoeshop/controllers/admin/product_admin_controller.dart';
import 'package:shoeshop/models/product.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shoeshop/views/admin/products/products_admindetail.dart';

class ProductsAdminPage extends StatefulWidget {
  const ProductsAdminPage({Key? key}) : super(key: key);

  @override
  State<ProductsAdminPage> createState() => _ProductsAdminPageState();
}

class _ProductsAdminPageState extends State<ProductsAdminPage> {
  final ProductAdminController productAdminController = Get.put(ProductAdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Admin'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductAdminDetailPage(
                  isEdit: true,
                ),
              ),
            );
          },
            icon: Icon(Icons.add),)
        ],
      ),
      body: Center(
        child: Obx(
              () => ListView.builder(
            itemCount: productAdminController.products.length,
            itemBuilder: (BuildContext context, int index) {
              Product product = productAdminController.products[index];
              return Slidable(
                child: ListTile(
                  leading: Image.network(
                    product.imageUrl!,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  subtitle: Text("${product.price}",
                      style: TextStyle(color: Colors.black, fontSize: 15)),
                ),
                endActionPane: ActionPane(
                  motion: ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductAdminDetailPage(
                                  isEdit: false, product: product,),
                            ));
                      },
                      label: "Xem",
                      icon: Icons.remove_red_eye,
                      foregroundColor: Colors.green,
                    ),
                    SlidableAction(
                      onPressed: (context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductAdminDetailPage(
                                isEdit: true, product: product,),
                            ));;
                      },
                      label: "Sửa",
                      icon: Icons.edit,
                      foregroundColor: Colors.blue,
                    ),
                    SlidableAction(
                      onPressed: (context) async {
                        _delete(context, product);
                      },
                      label: "Xóa",
                      icon: Icons.delete,
                      foregroundColor: Colors.red,
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _delete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () {
                // Xóa sản phẩm
                productAdminController.deleteProduct(product.id);
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
