import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddVoucherView extends StatefulWidget {
  const AddVoucherView({super.key});

  @override
  State<AddVoucherView> createState() => _AddVoucherPageState();
}

class _AddVoucherPageState extends State<AddVoucherView> {
  final _formKey = GlobalKey<FormState>();

  final _codeController = TextEditingController();
  final _minOrderValueController = TextEditingController();
  final _totalQuantityController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;

  String _discountType = 'Giảm tiền';
  String _status = 'Hoạt động';
  String _applyTo = 'Chọn món';
  String _usageLimitPerCustomer = '... lần';
  bool _isStackable = true;

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết Voucher')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Tên mã'),
                validator: (value) => value!.isEmpty ? 'Nhập tên mã' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _discountType,
                decoration: const InputDecoration(labelText: 'Loại giảm giá'),
                items: ['Giảm tiền', 'Giảm %']
                    .map((type) => DropdownMenuItem(value: type, child: Text('\$' + type)))
                    .toList(),
                onChanged: (value) => setState(() => _discountType = value!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _minOrderValueController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Giá trị đơn hàng tối thiểu'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _totalQuantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Số voucher tung ra'),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Thời gian áp dụng'),
                subtitle: Text(
                  _startDate != null && _endDate != null
                      ? '${dateFormat.format(_startDate!)} - ${dateFormat.format(_endDate!)}'
                      : 'Chưa chọn',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDateRange,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Trạng thái'),
                items: ['Hoạt động', 'Chờ duyệt', 'Không hoạt động']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (value) => setState(() => _status = value!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _applyTo,
                decoration: const InputDecoration(labelText: 'Áp dụng cho'),
                items: ['Chọn món', 'Toàn menu']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (value) => setState(() => _applyTo = value!),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _usageLimitPerCustomer,
                decoration: const InputDecoration(labelText: 'Mỗi khách dùng tối đa'),
                items: ['1 lần', '2 lần', '... lần']
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (value) => setState(() => _usageLimitPerCustomer = value!),
              ),
              const SizedBox(height: 12),
              const Text('Cộng dồn:'),
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      value: true,
                      groupValue: _isStackable,
                      title: const Text('Có thể dùng chung'),
                      onChanged: (value) => setState(() => _isStackable = value!),
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      value: false,
                      groupValue: _isStackable,
                      title: const Text('Không được dùng chung'),
                      onChanged: (value) => setState(() => _isStackable = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: submit logic
                    Get.back();
                  }
                },
                child: const Text('Tạo Voucher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}