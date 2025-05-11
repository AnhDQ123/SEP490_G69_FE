import 'package:ffb_fe_flutter/app/models/ship_payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../resources/util_common.dart';
import '../controllers/shop_manage_shipper_controller.dart';

class ShopManageShipperView extends GetView<ShopManageShipperController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        "Thống kê Shipper",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
      elevation: 2,
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            // Thêm chức năng lọc
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "Đang tải dữ liệu...",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      if (controller.shipperStats.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delivery_dining, size: 60, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                "Không có dữ liệu giao hàng",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Bạn chưa có giao dịch nào trong tháng này",
                style: TextStyle(color: Colors.grey[500]),
              ),
            ],
          ),
        );
      }

      return Column(
        children: [
          _buildHeader(),
          SizedBox(height: 8),
          Expanded(
            child: _buildShipperList(),
          ),
          _buildDebtNotification(),
        ],
      );
    });
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Tổng số shipper: ${controller.shipperStats.length}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blue[800],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "Tháng ${DateTime.now().month}/${DateTime.now().year}",
              style: TextStyle(
                color: Colors.green[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipperList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: controller.shipperStats.length,
      separatorBuilder: (context, index) => SizedBox(height: 8),
      itemBuilder: (context, index) {
        final stat = controller.shipperStats[index];
        return _buildShipperCard(stat);
      },
    );
  }

  Widget _buildShipperCard(ShipPaymentDTO stat) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.toNamed('/shipper-qr', arguments: {
            'userId': stat.shipperId,
          });
        },

        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[50],
                child: Icon(
                  Icons.delivery_dining,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat.shipperName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "ID: ${stat.shipperId}",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  UtilCommon.formatMoney(stat.amount),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDebtNotification() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange[50]!, Colors.orange[100]!],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange[300]!,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange[800]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lưu ý quan trọng",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Đây là danh sách các shipper mà bạn vẫn đang nợ tiền trong tháng này. Vui lòng thanh toán đúng hạn.",
                  style: TextStyle(
                    color: Colors.orange[900],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        // Thêm chức năng tạo mới hoặc thanh toán
      },
      child: Icon(Icons.payment, color: Colors.white),
      backgroundColor: Colors.blue[600],
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}