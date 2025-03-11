import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/foodOption.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../service/category_service.dart';
import '../../../service/product_service.dart';
import 'package:intl/intl.dart';


class ProductFormController extends GetxController {
  // Trường dữ liệu sản phẩm
  var productNameController = TextEditingController();
  var productDescriptionController = TextEditingController();
  var manufacturerController = TextEditingController();
  var supplierController = TextEditingController();
  var isEditing = false.obs;
  Product? product;

  // Số lượng sản phẩm
  var quantity = 0.obs;
  var quantityController = TextEditingController();

  // Danh mục sản phẩm
  var categories = <Category>[].obs;
  var selectedCategory = "".obs;

  // Gọi API lấy danh sách danh mục
  Future<void> loadCategories() async {
    try {
      var fetchedCategories = await CategoryService.fetchCategories();
      categories.assignAll(fetchedCategories);
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải danh mục: $e");
    }
  }

  Future<void> fetchProductDetail(int productId) async {
    product = await ProductService.fetchProductDetail(productId);
    if (product != null) {
      productNameController.text = product!.name;
      productDescriptionController.text = product!.description ?? "";
      manufacturerController.text = product!.manufacturer ?? "";
      supplierController.text = product!.supplier ?? "";
      quantity.value = product!.quantity!;
      quantityController.text = product!.quantity.toString();
      selectedCategory.value = product!.category ?? "";

      sizes.assignAll(product!.foodOptions?.where((o) => o.typeId == 2).toList() ?? []);
      foodOptions.assignAll(product!.foodOptions?.where((o) => o.typeId == 3).toList() ?? []);
    } else {
      Get.snackbar("Lỗi", "Không thể tải chi tiết sản phẩm!");
    }
  }

  // Hạn sử dụng (expiration)
  var expirationType = 'date'.obs; // "date", "hours", "days"
  var expirationValue = ''.obs; // Giá trị (ngày cụ thể hoặc số lượng)
  var durationController = TextEditingController(); // Khi chọn "hours" hoặc "days"
  var durationType = 'Giờ'.obs; // Dropdown chọn "Giờ" hoặc "Ngày"

  // Kích cỡ sản phẩm
  var sizes = <FoodOption>[].obs;
  var foodOptions = <FoodOption>[].obs;
  var sizeController = TextEditingController();
  var priceController = TextEditingController();

  // Hình ảnh sản phẩm
  final ImagePicker _picker = ImagePicker();
  var selectedMedia = Rxn<File>();
  get removeMedia => null;
  get pickMedia => null;

  @override
  void onInit() {
    super.onInit();
    int? productId = Get.arguments as int?;
    if (productId != null) {
      isEditing.value = true;
      fetchProductDetail(productId);
    }
  }

  //Số lượng
  void increaseQuantity() {
    if (quantity.value < 9999) {
      quantity.value++;
      quantityController.text = quantity.value.toString();
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 0) {
      quantity.value--;
      quantityController.text = quantity.value.toString(); // Cập nhật vào ô nhập
    }
  }

  // Chọn ngày hết hạn
  Future<void> selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // Cập nhật ngày đã chọn dưới dạng yyyy-MM-dd (định dạng chuẩn API yêu cầu)
      expirationValue.value = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      print("📆 Ngày hết hạn đã chọn: ${expirationValue.value}");
    }
  }


  //Update số lượng
  void updateQuantity(String value) {
    if (value.isNotEmpty) {
      int? newQuantity = int.tryParse(value);
      if (newQuantity != null) {
        if (newQuantity > 9999) {
          quantity.value = 9999; // Giới hạn tối đa 9999
        } else if (newQuantity < 0) {
          quantity.value = 0; // Không cho phép số âm
        } else {
          quantity.value = newQuantity;
        }
        quantityController.text = quantity.value.toString();
      }
    }
  }

  void addSizeOption(FoodOption size) {
    sizes.add(size);
  }

// Xóa kích cỡ theo index
  void removeSizeOption(int index) {
    sizes.removeAt(index);
  }

// Thêm lựa chọn sản phẩm mới
  void addFoodOption(FoodOption option) {
    foodOptions.add(option);
  }

// Xóa lựa chọn sản phẩm theo index
  void removeFoodOption(int index) {
    foodOptions.removeAt(index);
  }

  Future<void> saveProduct() async {
    if (productNameController.text.isEmpty) {
      Get.snackbar("Lỗi", "Tên sản phẩm không được để trống!");
      return;
    }

    // 🟢 Lấy ID của danh mục từ danh sách `categories`
    int? selectedCategoryId;
    for (var category in categories) {
      if (category.name == selectedCategory.value) {
        selectedCategoryId = category.id;
        break;
      }
    }

    if (selectedCategoryId == null) {
      Get.snackbar("Lỗi", "Vui lòng chọn danh mục hợp lệ!");
      return;
    }

    if (sizes.isEmpty) {
      Get.snackbar("Lỗi", "Vui lòng thêm ít nhất một kích cỡ sản phẩm!");
      return;
    }

    String? formattedExpiryDate = expirationValue.value.isNotEmpty ? expirationValue.value : null;

    // 🟢 In log kiểm tra giá trị trước khi gửi
    print("📡 Ngày hết hạn trước khi gửi API: $formattedExpiryDate");

    // 🟢 Gộp Size (`typeId = 2`) và Option (`typeId = 3`)
    List<FoodOption> allOptions = [
      ...sizes.map((size) => FoodOption(
        id: 0, // ID sẽ được tạo tự động bởi Backend
        name: size.name,
        price: size.price,
        typeId: 2, // 🟢 Định rõ đây là SIZE
      )),
      ...foodOptions.map((option) => FoodOption(
        id: 0,
        name: option.name,
        price: option.price,
        typeId: 3, // 🟢 Định rõ đây là OPTION
      )),
    ];

    // 🟢 Tạo Product object để gửi API
    Product newProduct = Product(
      id: isEditing.value ? product!.id : 0, // 🟢 ID sản phẩm sẽ do Backend tạo
      name: productNameController.text,
      description: productDescriptionController.text.isNotEmpty ? productDescriptionController.text : null,
      manufacturer: manufacturerController.text.isNotEmpty ? manufacturerController.text : null,
      supplier: supplierController.text.isNotEmpty ? supplierController.text : null,
      quantity: quantity.value,
      category: selectedCategoryId.toString(),
      discount: null,
      avatar: selectedMedia.value?.path,
      expiryDate: formattedExpiryDate, // 🟢 Định dạng `yyyy-MM-dd`
      foodOptions: allOptions, // 🟢 Gửi đầy đủ danh sách `foodOption` với `typeId`
    );

    bool success = await ProductService.createProduct(
      newProduct,
      selectedMedia.value,
      [],
    );

    if (success) {
      Get.snackbar("Thành công", "Sản phẩm đã được ${isEditing.value ? 'cập nhật' : 'thêm'}!");
      Get.back();
    } else {
      Get.snackbar("Lỗi", "Không thể lưu sản phẩm.");
    }
  }
}

class ImagePickerController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var selectedMedia = Rxn<File>(); // Chỉ được phép chọn 1 ảnh

  // Chọn ảnh từ thư viện
  Future<void> pickMedia() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedMedia.value = File(pickedFile.path);
    }
  }

  // Xóa ảnh đã chọn
  void removeMedia() {
    selectedMedia.value = null;
  }
}
