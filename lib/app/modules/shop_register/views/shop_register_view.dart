import 'dart:io';

import '../../../models/bank.dart';
import 'step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shop_register_controller.dart';

class ShopRegisterView extends GetView<ShopRegisterController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentStep.value > 0) {
          controller.previousStep(); // Quay lại step trước
          return false; // Chặn thoát ứng dụng
        }
        return true; // Thoát ứng dụng nếu đang ở Step 0
      },
      child:
      Scaffold(
        appBar: AppBar(title: Text("Đăng ký cửa hàng")),
        body: Column(
          children: [
            StepIndicator(),

            Expanded(
              child: Obx(() {
                final step = controller.currentStep.value; // đảm bảo Obx phụ thuộc vào biến Rx
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: _buildStepContent(),
                      ),
                    );
                  },
                );
              }),
            ),


            // Nút "Quay lại" & "Tiếp tục"
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Obx(() =>
                      Visibility(
                        visible: controller.currentStep.value > 0,
                        child: Expanded(
                          child: ElevatedButton(
                            onPressed: controller.previousStep,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
                            child: Text("Quay lại"),
                          ),
                        ),
                      )),
                  SizedBox(width: 12),
                  Obx(() => Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        switch (controller.currentStep.value) {
                          case 0:
                            if (controller.selectedService.value == null) {
                              Get.snackbar("Thông báo", "Vui lòng chọn đủ thông tin trước khi tiếp tục.");
                              return;
                            }
                            break;

                          case 1:
                            if (!controller.isTermsAccepted.value) {
                              Get.snackbar("Thông báo", "Bạn cần đồng ý với điều khoản trước khi tiếp tục.");
                              return;
                            }
                            break;

                          case 2:
                            if (controller.shopName.value.isEmpty ||
                                controller.openTime.value == null ||
                                controller.closeTime.value == null ||
                                controller.address.value.isEmpty ||
                                controller.phoneNumber.value.isEmpty) {
                              Get.snackbar("Thông báo", "Vui lòng điền đầy đủ thông tin cửa hàng trước khi tiếp tục.");
                              return;
                            }
                            break;

                          case 3:
                            if (controller.idCardFrontImage.value == null ||
                                controller.idCardBackImage.value == null ||
                                controller.issuedDate.value == null ||
                                controller.registrationCertificateImage.value == null ||
                                controller.safetyPolicyImage.value != null &&
                                controller.taxCode.value.isEmpty) {
                              Get.snackbar("Thông báo", "Vui lòng tải lên đầy đủ giấy tờ theo yêu cầu.");
                              return;
                            }
                            break;

                          default:
                            break;
                        }
                        controller.nextStep();
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: _getButtonColor(),
                        minimumSize: Size(double.infinity, 50), // Đảm bảo nút rộng ngang
                      ),
                      child: controller.currentStep.value == 3
                          ? Obx(() => controller.isSubmitting.value
                          ? CircularProgressIndicator(color: Colors.white) // Hiển thị loading khi gửi API
                          : Text("Đăng ký"))
                          : Text("Tiếp tục"),
                    ),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getButtonColor() {
    switch (controller.currentStep.value) {
      case 0:
        return (controller.selectedService.value != null)
            ? Colors.orange
            : Color(0xFFD3D3D3);
      case 1:
        return controller.isTermsAccepted.value
            ? Colors.orange
            : Color(0xFFD3D3D3);
      case 2:
        return (controller.shopName.value.isNotEmpty &&
            controller.openTime.value != null &&
            controller.closeTime.value != null &&
            controller.address.value.isNotEmpty &&
            controller.phoneNumber.value.isNotEmpty &&
            controller.logo.value != null)
            ? Colors.orange
            : Color(0xFFD3D3D3);
      case 3:
        return (controller.idCardFrontImage.value != null &&
            controller.idCardBackImage.value != null &&
            controller.issuedDate.value != null &&
            controller.registrationCertificateImage.value != null &&
            controller.safetyPolicyImage.value != null &&
            controller.taxCode.value.isNotEmpty &&
            controller.selectedBank.value != null &&
            controller.bankInfo.value.isNotEmpty
            )
            ? Colors.orange
            : Color(0xFFD3D3D3);
      default:
        return Colors.black;
    }
  }


  Widget _buildStepContent() {
    switch (controller.currentStep.value) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      default:
        return Container();
    }
  }

  Widget _buildStep1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vui lòng chọn loại hình dịch vụ",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          _buildServiceOption(
            title: "Đồ ăn nhanh",
            description:
            "Món chủ đạo của cửa hàng là món ăn/Thức uống được chế biến nhằm phục vụ cho mục đích ăn nhanh với trạng thái món ở mức độ cao nhất có thể như: bún, phở, mì, cơm, cháo vẫn còn nóng...",
            value: "COOKED",
          ),
          SizedBox(height: 8),
          _buildServiceOption(
            title: "Thực phẩm tươi sống",
            description:
            "Sản phẩm chủ đạo của cửa hàng là các sản phẩm có chất lượng và độ tươi sống đạt chuẩn, thường là các mặt hàng như thịt, cá, rau củ quả tươi...",
            value: "FRESH",
          ),
        ],
      ),
    );
  }

  Widget _buildServiceOption({
    required String title,
    required String description,
    required String value,
  }) {
    return Obx(() => GestureDetector(
      onTap: () {
        controller.selectedService(value);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: controller.selectedService.value == value
                ? Colors.black
                : Colors.grey,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio<String>(
                  value: value,
                  groupValue: controller.selectedService.value,
                  onChanged: (val) {
                    controller.selectedService(val!);
                  },
                ),
                Expanded(
                  child: Text(
                    title,
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(description),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildStep2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vui lòng đọc kỹ điều khoản và điều kiện",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          _buildTermsCard(),
          SizedBox(height: 12),
          Obx(() => CheckboxListTile(
            value: controller.isTermsAccepted.value,
            onChanged: (value) {
              controller.isTermsAccepted(value!);
            },
            title: Text(
              "Tôi xác nhận rằng đã đọc tất cả các điều khoản và điều kiện nêu trên và đồng ý với Fast F&B để trở thành đối tác bán hàng của Fast F&B",
              style: TextStyle(fontSize: 14),
            ),
            controlAffinity: ListTileControlAffinity.leading,
          )),
          SizedBox(height: 8),
          Text(
            "• Bằng việc tiếp tục đăng ký, Đối tác đồng ý sẽ chịu toàn bộ trách nhiệm liên quan đến việc đăng bán **SẢN PHẨM BỊ CẤM** trên Fast F&B",
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Icon(Icons.picture_as_pdf, size: 40, color: Colors.black),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "Điều khoản và điều kiện",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: Icon(Icons.download, color: Colors.black),
            onPressed: () {
              // TODO: logic tải file PDF điều khoản
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Thông tin cơ bản",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),

          // Logo cửa hàng
          // Logo cửa hàng
          buildLogoUploader(
            imageController: controller.logo,
            onGalleryPick: () => controller.pickImageFromGallery(controller.logo),
            onCameraPick: () => controller.pickImageFromCamera(controller.logo),
            onRemove: () => controller.removeImage(controller.logo),
          ),
          SizedBox(height: 12),

          // Tên cửa hàng
          _buildTextField( controller.shopName, label: "Tên cửa hàng*", isRequired: true),

          // Giờ mở cửa & Giờ đóng cửa
          Row(
            children: [
              Expanded(child: _buildTimePicker("Giờ mở cửa", controller.openTime)),
              SizedBox(width: 12),
              Expanded(child: _buildTimePicker("Giờ đóng cửa", controller.closeTime)),
            ],
          ),

          // Địa chỉ
          _buildTextField(controller.address, label: "Địa chỉ", isRequired: true),

          // Số điện thoại
          _buildTextField(controller.phoneNumber, label: "Số điện thoại", isRequired: true),

          // Miêu tả (không bắt buộc)
          _buildTextField(controller.description, label: "Miêu tả", isRequired: false),
        ],
      ),
    );
  }

  Widget _buildTimePicker(String label, Rxn<TimeOfDay> timeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            children: [
              TextSpan(
                text: " *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: Get.context!,
              initialTime: TimeOfDay.now(),
            );
            if (pickedTime != null) {
              timeController.value = pickedTime;
            }
          },
          child: Obx(() => Container(
            width: double.infinity, // Giúp mở rộng toàn bộ chiều ngang
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              controller.formatTime(timeController.value).isEmpty
                  ? "Chọn giờ"
                  : controller.formatTime(timeController.value),
              style: TextStyle(
                fontSize: 16,
                color: controller.formatTime(timeController.value).isEmpty
                    ? Colors.grey
                    : Colors.black87,
              ),
            ),
          )),
        ),
        SizedBox(height: 8),
      ],
    );
  }

  // Widget input
  Widget _buildTextField(RxString controllerValue, {String label = "", bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            children: isRequired
                ? [
              TextSpan(
                text: " *",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ]
                : [],
          ),
        ),
        SizedBox(height: 4),
        TextField(
          onChanged: (value) => controllerValue.value = value,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }


  Widget _buildStep4() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vui lòng chuẩn bị các giấy tờ liên quan",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Vui lòng xem và điền các giấy tờ liên quan để xác thực cho việc đăng ký cửa hàng",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Text("Thông tin, giấy tờ cần chuẩn bị",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            // Số CCCD/CMND/Hộ chiếu
            _buildTextField(controller.idCard, label: "Số CCCD/CMND/Hộ chiếu", isRequired: true),

            // Ảnh mặt trước CCCD
            buildImageUploader(
              label: "Mặt trước CCCD/CMND",
              imageController: controller.idCardFrontImage,
              onGalleryPick: () => controller.pickImageFromGallery(controller.idCardFrontImage),
              onCameraPick: () => controller.pickImageFromCamera(controller.idCardFrontImage),
              onRemove: () => controller.removeImage(controller.idCardFrontImage),
              isCCCD: true
            ),

            const SizedBox(height: 12),

            // Ảnh mặt sau CCCD
            buildImageUploader(
              label: "Mặt sau CCCD/CMND",
              imageController: controller.idCardBackImage,
              onGalleryPick: () => controller.pickImageFromGallery(controller.idCardBackImage),
              onCameraPick: () => controller.pickImageFromCamera(controller.idCardBackImage),
              onRemove: () => controller.removeImage(controller.idCardBackImage),
              isCCCD: true
            ),

            const SizedBox(height: 12),

            // Ngày hết hạn CCCD
            _buildDatePicker("Ngày hết hạn", controller.issuedDate),

            const SizedBox(height: 12),

            // Ảnh giấy phép kinh doanh
            // Hai ảnh "Giấy phép đăng ký kinh doanh" và "Giấy phép an toàn thực phẩm" cùng một hàng
            Row(
              children: [
                Expanded(
                  child: buildImageUploader(
                    label: "Giấy phép đăng ký kinh doanh",
                    imageController: controller.registrationCertificateImage,
                    onGalleryPick: () => controller.pickImageFromGallery(controller.registrationCertificateImage),
                    onCameraPick: () => controller.pickImageFromCamera(controller.registrationCertificateImage),
                    onRemove: () => controller.removeImage(controller.registrationCertificateImage),
                    isLicense: true, // ✅ Hiển thị ảnh dọc nhưng nhỏ lại
                  ),
                ),
                SizedBox(width: 12), // Khoảng cách giữa hai ảnh
                Expanded(
                  child: buildImageUploader(
                    label: "Giấy phép an toàn thực phẩm",
                    imageController: controller.safetyPolicyImage,
                    onGalleryPick: () => controller.pickImageFromGallery(controller.safetyPolicyImage),
                    onCameraPick: () => controller.pickImageFromCamera(controller.safetyPolicyImage),
                    onRemove: () => controller.removeImage(controller.safetyPolicyImage),
                    isLicense: true, // ✅ Hiển thị ảnh dọc nhưng nhỏ lại
                  ),
                ),
              ],
            ),


            const SizedBox(height: 12),

            // Ảnh sản phẩm (cho phép nhiều ảnh)
            buildImageUploader(
              label: "Ảnh sản phẩm",
              imageController: controller.productImage,
              onGalleryPick: () => controller.pickImageFromGallery(controller.productImage),
              onCameraPick: () => controller.pickImageFromCamera(controller.productImage),
              onRemove: () => controller.removeImage(controller.productImage),
            ),

            const SizedBox(height: 12),

            _buildTextField(controller.taxCode, label: "Má số thuế", isRequired: true),



            Text("Chọn ngân hàng*", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4,),
            Obx(() => controller.isLoadingBanks.value
                ? Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<Bank>(
              value: controller.selectedBank.value,
              isExpanded: true, // Đảm bảo dropdown mở rộng đủ không gian
              items: controller.bankList.map((bank) {
                return DropdownMenuItem<Bank>(
                  value: bank,
                  child: Text(bank.shortName, overflow: TextOverflow.ellipsis), // Tránh bị tràn text
                );
              }).toList(),
              onChanged: (Bank? value) {
                controller.selectedBank.value = value;
                controller.selectedBankBin.value = value?.bin ?? ''; // Lưu giá trị BIN
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Chọn ngân hàng",
              ),
            )),

            const SizedBox(height: 12),

            _buildTextField(controller.bankInfo, label: "Số tài khoản ngân hàng", isRequired: true),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget tải lên logo
  Widget buildImageUploader({
    required String label,
    required Rxn<File> imageController,
    required Function() onGalleryPick,
    required Function() onCameraPick,
    required Function() onRemove,
    bool isCCCD = false,
    bool isLicense = false,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width; // ✅ Chiều rộng màn hình
        double width = isCCCD ? screenWidth : (isLicense ? screenWidth * 0.45 : 120);
        double height = isCCCD ? width * 0.6 : (isLicense ? width * 1.5 : 120);
        double borderRadius = 12;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),

            GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.camera_alt),
                          title: Text("Chụp ảnh"),
                          onTap: () {
                            onCameraPick();
                            Get.back();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.photo_library),
                          title: Text("Chọn từ thư viện"),
                          onTap: () {
                            onGalleryPick();
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: imageController.value == null
                        ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Image.file(
                        imageController.value!,
                        width: width,
                        height: height,
                        fit: BoxFit.cover, // ✅ Ảnh giữ đúng tỷ lệ, không méo
                      ),
                    ),
                  ),
                  if (imageController.value != null)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }




  Widget buildLogoUploader({
    required Rxn<File> imageController,
    required Function() onGalleryPick,
    required Function() onCameraPick,
    required Function() onRemove,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa nội dung
      children: [
        RichText(
          text: TextSpan(
            text: "Logo cửa hàng ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
            children: [
              TextSpan(
                text: "*",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),

        Center( // Căn giữa toàn bộ khung logo
          child: Obx(() => GestureDetector(
            onTap: () {
              Get.bottomSheet(
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.camera_alt),
                        title: Text("Chụp ảnh"),
                        onTap: () {
                          onCameraPick();
                          Get.back();
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_library),
                        title: Text("Chọn từ thư viện"),
                        onTap: () {
                          onGalleryPick();
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center, // Căn giữa icon xoá
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                  ),
                  child: imageController.value == null
                      ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                      : ClipOval(
                    child: Image.file(
                      imageController.value!,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (imageController.value != null)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: onRemove,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        padding: EdgeInsets.all(4),
                        child: Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, Rxn<DateTime> dateController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: Get.context!,
              initialDate: dateController.value ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            if (pickedDate != null) {
              dateController.value = pickedDate;
            }
          },
          child: Obx(() => Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              dateController.value != null
                  ? "${dateController.value!.day}/${dateController.value!.month}/${dateController.value!.year}"
                  : "Chọn ngày",
              style: TextStyle(
                fontSize: 16,
                color: dateController.value != null ? Colors.black87 : Colors.grey,
              ),
            ),
          )),
        ),
        SizedBox(height: 8),
      ],
    );
  }


}