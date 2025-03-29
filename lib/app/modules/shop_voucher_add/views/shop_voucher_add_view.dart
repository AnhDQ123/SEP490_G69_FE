// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/shop_voucher_add_controller.dart';
// import '../../../models/voucher.dart';
// import '../../../routes/app_pages.dart';
//
// class ShopVoucherAddView extends StatelessWidget {
//   final controller = Get.put(ShopVoucherAddController());
//   final bool isEdit;
//   final Voucher? voucher;
//
//   ShopVoucherAddView({this.isEdit = false, this.voucher});
//
//   @override
//   Widget build(BuildContext context) {
//     if (isEdit && voucher != null) {
//       controller.initialize(voucher!);  // Nạp thông tin voucher khi edit
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(isEdit ? "Chỉnh sửa Voucher" : "Tạo Mới Voucher"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: controller.codeController,
//                 decoration: InputDecoration(
//                   labelText: 'Mã giảm giá',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập mã giảm giá';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               DropdownButtonFormField<String>(
//                 value: controller.discountType.value,
//                 onChanged: (value) => controller.discountType.value = value!,
//                 items: ['PERCENTAGE', 'AMOUNT'].map((type) {
//                   return DropdownMenuItem<String>(
//                     value: type,
//                     child: Text(type),
//                   );
//                 }).toList(),
//                 decoration: InputDecoration(labelText: 'Loại giảm giá'),
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: controller.discountValueController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(labelText: 'Giá trị giảm giá'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập giá trị giảm giá';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: controller.minOrderValueController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(labelText: 'Giá trị đơn hàng tối thiểu'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Vui lòng nhập giá trị tối thiểu';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: controller.totalVouchersController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(labelText: 'Số lượng voucher'),
//               ),
//               SizedBox(height: 16),
//               TextFormField(
//                 controller: controller.maxUsagePerCustomerController,
//                 keyboardType: TextInputType.number,
//                 decoration: InputDecoration(labelText: 'Giới hạn sử dụng trên mỗi khách hàng'),
//               ),
//               SizedBox(height: 16),
//               CheckboxListTile(
//                 title: Text('Có thể cộng dồn'),
//                 value: controller.isStackable.value,
//                 onChanged: (value) {
//                   controller.isStackable.value = value!;
//                 },
//               ),
//               SizedBox(height: 16),
//               DateTimeField(
//                 controller: controller.startDateController,
//                 decoration: InputDecoration(labelText: 'Ngày bắt đầu'),
//                 onShowPicker: (context, currentValue) async {
//                   final date = await showDatePicker(
//                     context: context,
//                     initialDate: currentValue ?? DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2101),
//                   );
//                   return date;
//                 },
//               ),
//               SizedBox(height: 16),
//               DateTimeField(
//                 controller: controller.endDateController,
//                 decoration: InputDecoration(labelText: 'Ngày kết thúc'),
//                 onShowPicker: (context, currentValue) async {
//                   final date = await showDatePicker(
//                     context: context,
//                     initialDate: currentValue ?? DateTime.now(),
//                     firstDate: DateTime(2000),
//                     lastDate: DateTime(2101),
//                   );
//                   return date;
//                 },
//               ),
//               SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: () {
//                   if (isEdit) {
//                     controller.updateVoucher(voucher!);  // Chỉnh sửa voucher
//                   } else {
//                     controller.addVoucher();  // Tạo voucher mới
//                   }
//                 },
//                 child: Text(isEdit ? "Cập nhật Voucher" : "Tạo mới Voucher"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
