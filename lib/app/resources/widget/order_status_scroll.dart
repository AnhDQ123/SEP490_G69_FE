import 'package:flutter/material.dart';

class OrderStatusScroll extends StatelessWidget {
  final List<Map<String, dynamic>> statuses = [
    {"icon": Icons.access_time, "label": "Chờ xác nhận"},
    {"icon": Icons.local_shipping, "label": "Đang chuẩn bị"},
    {"icon": Icons.delivery_dining, "label": "Đang giao"},
    {"icon": Icons.done, "label": "Đã giao"},
    {"icon": Icons.cancel, "label": "Đã huỷ"},
    {"icon": Icons.replay, "label": "Hoàn tiền"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      color: Colors.grey.shade200,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: statuses.map((status) {
            return Container(
              width: 110,
              height: 100,
              margin: EdgeInsets.symmetric(horizontal: 6),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(status["icon"], color: Colors.black54, size: 28),
                  SizedBox(height: 5),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        height: 40,
                        child: IntrinsicWidth(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  status["label"],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
