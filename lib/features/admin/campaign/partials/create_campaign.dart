import 'package:flutter/material.dart';
import '../../../../core/network/product/product_network.dart';
import '../../../../core/network/campaign/campaign.network.dart';
import '../../../../core/network/campaign/req/index.dart';
import '../../../../core/network/product/res/index.dart';
import 'package:intl/intl.dart';

class CreateCampaignDialog extends StatefulWidget {
  final Function onCampaignCreated;

  const CreateCampaignDialog({Key? key, required this.onCampaignCreated})
    : super(key: key);

  @override
  _CreateCampaignDialogState createState() => _CreateCampaignDialogState();
}

class _CreateCampaignDialogState extends State<CreateCampaignDialog> {
  final _formKey = GlobalKey<FormState>();
  late Future<ProductResponse>
  _productsFuture; // Change type to ProductResponse
  String? _selectedProductId;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _minQuantityController = TextEditingController();
  final TextEditingController _maxQuantityController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductNetwork.getProductList();
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now;
    final DateTime lastDate = DateTime(2030); // Extended the last date to 2030

    final DateTime? picked = await showDateTimePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      // Format the date in UTC format with Z suffix
      final formattedDate = picked.toUtc().toIso8601String();
      setState(() {
        controller.text = formattedDate;
      });
    }
  }

  String? _validateEndDate(String? value) {
    if (value?.isEmpty ?? true) {
      return 'Please select end date';
    }

    final startDate = DateTime.parse(_startDateController.text);
    final endDate = DateTime.parse(value!);

    if (endDate.isBefore(startDate)) {
      return 'End date must be after start date';
    }

    return null;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedProductId != null) {
      try {
        final request = CreateCampaignRequest(
          name: _nameController.text,
          startDate: _startDateController.text,
          endDate: _endDateController.text,
          minQuantity: int.parse(_minQuantityController.text),
          maxQuantity: int.parse(_maxQuantityController.text),
          totalAmount: double.parse(_totalAmountController.text),
          status: "ACTIVE",
          productId: _selectedProductId!,
        );

        await CampaignNetwork.createCampaign(request);

        // Close the dialog first
        Navigator.of(context).pop();

        // Then call the callback
        widget.onCampaignCreated();
      } catch (e) {
        print('Error creating campaign: $e');
        // Show error in the dialog instead of using SnackBar
        if (mounted) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to create campaign: $e'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create New Campaign',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Campaign Name'),
                  validator:
                      (value) =>
                          value?.isEmpty ?? true ? 'Please enter a name' : null,
                ),
                SizedBox(height: 16),
                FutureBuilder<ProductResponse>(
                  // Change type to ProductResponse
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error loading products');
                    }
                    final products =
                        snapshot.data?.data.content ??
                        []; // Access content from response
                    return DropdownButtonFormField<String>(
                      value: _selectedProductId,
                      hint: Text('Select Product'),
                      items:
                          products.map((product) {
                            // Remove cast as it's now properly typed
                            return DropdownMenuItem(
                              value: product.id,
                              child: Text(product.name),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedProductId = value;
                        });
                      },
                      validator:
                          (value) =>
                              value == null ? 'Please select a product' : null,
                    );
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _startDateController,
                  decoration: InputDecoration(labelText: 'Start Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, _startDateController),
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? 'Please select start date'
                              : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _endDateController,
                  decoration: InputDecoration(labelText: 'End Date'),
                  readOnly: true,
                  onTap: () => _selectDate(context, _endDateController),
                  validator: _validateEndDate,
                  // validator:
                  //     (value) =>
                  //         value?.isEmpty ?? true
                  //             ? 'Please select end date'
                  //             : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _minQuantityController,
                  decoration: InputDecoration(labelText: 'Minimum Quantity'),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? 'Please enter minimum quantity'
                              : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _maxQuantityController,
                  decoration: InputDecoration(labelText: 'Maximum Quantity'),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? 'Please enter maximum quantity'
                              : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _totalAmountController,
                  decoration: InputDecoration(labelText: 'Total Amount'),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value?.isEmpty ?? true
                              ? 'Please enter total amount'
                              : null,
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Cancel'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Create'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _minQuantityController.dispose();
    _maxQuantityController.dispose();
    _totalAmountController.dispose();
    super.dispose();
  }
}

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  final DateTime? date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );
  if (date == null) return null;

  final TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );
  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
