import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoeshop/controllers/admin/product_admin_controller.dart';
import 'package:shoeshop/helper/dialogs.dart';
import 'package:shoeshop/models/product.dart';
import 'package:shoeshop/services/firebase_services.dart';
import 'dart:io';

import 'package:shoeshop/utils/image_path.dart';

class ProductAdminDetailPage extends StatefulWidget {
  final bool isEdit;
  final Product? product;

  const ProductAdminDetailPage({
    Key? key,
    required this.isEdit,
    this.product,
  }) : super(key: key);

  @override
  _ProductAdminDetailPageState createState() => _ProductAdminDetailPageState();
}

class _ProductAdminDetailPageState extends State<ProductAdminDetailPage> {
  Product? product;
  bool? isEdit;

  bool _imageChange = false;
  XFile? _xImage;

  String title = "Thêm sản phẩm mới";
  String buttonLabel = "Thêm";

  late TextEditingController idController;
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  final ProductAdminController productAdminController = Get.find();

  @override
  void initState() {
    super.initState();

    isEdit = widget.isEdit;
    product = widget.product;

    idController = TextEditingController();

    if (isEdit == false) {
      buttonLabel = "Đóng";
      title = "Xem thông tin sản phẩm";
      idController.text = product!.id;
    } else if (product != null) {
      idController.text = product!.id;
      buttonLabel = "Sửa";
      title = "Sửa thông tin sản phẩm";
    } else {
      FirebaseService().getNextProductId().then((productId) {
        idController.text = productId;
      });
    }

    nameController = TextEditingController(text: product?.name ?? '');
    priceController = TextEditingController(text: product?.price?.toString() ?? '');
    descriptionController = TextEditingController(text: product?.description ?? '');

  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
                height: 200,
                child: _imageChange
                    ? Image.file(File(_xImage!.path))
                    : product?.imageUrl != null
                    ? Image.network(product!.imageUrl!)
                    : Image.asset(ImagePath.imgImageUpload)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: isEdit == true ? () => _chooseImage(context) : null,
                    child: const Icon(Icons.image)),
              ],
            ),
            TextFormField(
              controller: idController,
              decoration: InputDecoration(labelText: 'ID'),
              readOnly: true,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                if (widget.product != null) {
                  widget.product!.name = value;
                }
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                if (widget.product != null) {
                  widget.product!.price = double.parse(value);
                }
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onChanged: (value) {
                if (widget.product != null) {
                  widget.product!.description = value;
                }
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (widget.isEdit == false) {
                  Navigator.pop(context);
                } else {
                  if (nameController.text.isEmpty || priceController.text.isEmpty || descriptionController.text.isEmpty) {
                      showSnackBar(context, "Vui lòng điền đầy đủ thông tin", 3);
                  } else  if (double.tryParse(priceController.text) == null) {
                    showSnackBar(context, "Giá trị sản phẩm không hợp lệ!", 3);
                  } else {
                    _update(context);
                    Get.back();
                  }
                }
              },
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }

  _chooseImage(BuildContext context) async {
    _xImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (_xImage != null) {
      setState(() {
        _imageChange = true;
      });
    }
  }

  _update(BuildContext context) async {
    showSnackBar(context, "Đang cập nhật dữ liệu", 60);

      Product updatedProduct = Product(
        id: idController.text,
        name: nameController.text,
        description: descriptionController.text,
        price: double.parse(priceController.text),
        imageUrl: null,
      );
      // Gọi hàm editProduct từ productAdminController

    if (_imageChange) {
      FirebaseStorage _storage = FirebaseStorage.instance;
      Reference reference =
      _storage.ref().child("products").child("products_${updatedProduct?.id}.jpg");
      UploadTask uploadTask = await _uploadTask(reference, _xImage!);
      uploadTask.whenComplete(() async {
        updatedProduct?.imageUrl = await reference.getDownloadURL();
        if (product != null) {
          productAdminController.editProduct(updatedProduct);
          showSnackBar(context, "Cập nhật sản phẩm thành công!", 3);
        } else {
          productAdminController.addProduct(updatedProduct);
          showSnackBar(context, "Thêm sản phẩm thành công!", 3);
        }
      });
    }
  }

  Future<UploadTask> _uploadTask(Reference reference, XFile xImage) async {
    final metaData = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': xImage.path});
    UploadTask uploadTask;
    if (kIsWeb)
      uploadTask = reference.putData(await xImage.readAsBytes(), metaData);
    else
      uploadTask = reference.putFile(File(xImage.path), metaData);
    return Future.value(uploadTask);
  }
}
