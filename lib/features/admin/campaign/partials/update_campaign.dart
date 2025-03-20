import 'package:flutter/material.dart';
import '../../../../core/network/product/product_network.dart';
import '../../../../core/network/campaign/campaign.network.dart';
import '../../../../core/network/campaign/req/index.dart';
import '../../../../core/network/product/res/index.dart';
import 'package:intl/intl.dart';

class UpdateCampaignDialog extends StatefulWidget {
  final String campaignId;
  final Function? onCampaignUpdated;

  const UpdateCampaignDialog({
    Key? key,
    required this.campaignId,
    this.onCampaignUpdated,
  }) : super(key: key);

  @override
  _UpdateCampaignDialogState createState() => _UpdateCampaignDialogState();
}

class _UpdateCampaignDialogState extends State<UpdateCampaignDialog> {
  final _formKey = GlobalKey<FormState>();
  Future<ProductResponse> _productsFuture = Future.value(
    ProductResponse(
      message: '',
      data: ProductData(
        content: [],
        totalPages: 0,
        totalElements: 0,
        first: true,
        last: true,
        size: 0,
        number: 0,
      ),
    ),
  );
  String? _selectedProductId;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _minQuantityController = TextEditingController();
  final TextEditingController _maxQuantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCampaignDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  void _loadCampaignDetails() async {
    final campaign = await CampaignNetwork.getCampaignById(widget.campaignId);
    setState(() {
      _nameController.text = campaign.campaign.name;
      _startDateController.text = campaign.campaign.startDate.toString();
      _endDateController.text = campaign.campaign.endDate.toString();
      _minQuantityController.text = campaign.campaign.minQuantity.toString();
      _maxQuantityController.text = campaign.campaign.maxQuantity.toString();
      _selectedProductId = campaign.campaign.product.id;
    });
  }

  void _loadProducts() {
    setState(() {
      _productsFuture = ProductNetwork.getProductList();
    });
  }

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = now;
    final DateTime lastDate = DateTime(2030);

    await Future.delayed(Duration.zero);

    final DateTime? picked = await showDateTimePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && mounted) {
      Future.microtask(() {
        if (mounted) {
          setState(() {
            controller.text = picked.toUtc().toIso8601String();
          });
        }
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
        final startDate = DateTime.parse(_startDateController.text);
        final endDate = DateTime.parse(_endDateController.text);

        final startDateStr = startDate.toIso8601String().split('.')[0] + 'Z';
        final endDateStr = endDate.toIso8601String().split('.')[0] + 'Z';

        const double totalAmount = 0.0;

        final request = UpdateCampaignRequest(
          id: widget.campaignId,
          name: _nameController.text.trim(),
          startDate: startDateStr,
          endDate: endDateStr,
          minQuantity: int.parse(_minQuantityController.text),
          maxQuantity: int.parse(_maxQuantityController.text),
          totalAmount: totalAmount,
          productId: _selectedProductId!,
        );

        await CampaignNetwork.updateCampaign(request);

        if (widget.onCampaignUpdated != null) {
          widget.onCampaignUpdated!();
        }

        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        print('Error updating campaign: $e');

        String errorMessage = 'Failed to update campaign';

        if (e.toString().contains('409')) {
          errorMessage =
              'A campaign with this name already exists. Please use a different name.';
        }

        if (mounted) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text(
                    'Error',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.grey),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK', style: TextStyle(color: Colors.blue)),
                    ),
                  ],
                ),
          );
        }
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    IconData? prefixIcon,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon:
              prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.blue, size: 20)
                  : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade300, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(30, 40, 30, 30),
              margin: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Update Campaign',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Center(
                        child: Text(
                          'Modify your product campaign parameters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      _buildTextField(
                        controller: _nameController,
                        label: 'Campaign Name',
                        prefixIcon: Icons.campaign,
                        validator:
                            (value) =>
                                value?.isEmpty ?? true
                                    ? 'Please enter a campaign name'
                                    : null,
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: FutureBuilder<ProductResponse>(
                          future: _productsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.blue,
                                              ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text(
                                        'Loading products...',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.shade300,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        color: Colors.red.shade400,
                                        size: 20,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Failed to load products',
                                        style: TextStyle(
                                          color: Colors.red.shade400,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (snapshot.data == null ||
                                snapshot.data!.data.content.isEmpty) {
                              return Container(
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'No products available',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final products = snapshot.data!.data.content;

                            return Theme(
                              data: Theme.of(
                                context,
                              ).copyWith(canvasColor: Colors.white),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.08),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedProductId,
                                  hint: Text(
                                    'Select Product',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  icon: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                  ),
                                  isExpanded: true,
                                  dropdownColor: Colors.white,
                                  menuMaxHeight: 300,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 1.5,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.red.shade300,
                                        width: 1.5,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Colors.red.shade400,
                                        width: 1.5,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    prefixIcon: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Icon(
                                        Icons.shopping_bag_outlined,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                    ),
                                    prefixIconConstraints: BoxConstraints(
                                      minWidth: 50,
                                      minHeight: 40,
                                    ),
                                    labelText: "Product",
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  selectedItemBuilder: (BuildContext context) {
                                    return products.map<Widget>((
                                      Product product,
                                    ) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(left: 16),
                                        child: Text(
                                          product.name,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      );
                                    }).toList();
                                  },
                                  items:
                                      products.map((product) {
                                        return DropdownMenuItem<String>(
                                          value: product.id,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child:
                                                      product
                                                              .imageProducts
                                                              .isNotEmpty
                                                          ? ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  6,
                                                                ),
                                                            child: Image.network(
                                                              product
                                                                  .imageProducts
                                                                  .first
                                                                  .imageUrl,
                                                              width: 30,
                                                              height: 30,
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (
                                                                context,
                                                                error,
                                                                stackTrace,
                                                              ) {
                                                                return Icon(
                                                                  Icons
                                                                      .image_not_supported_outlined,
                                                                  size: 16,
                                                                  color: Colors
                                                                      .blue
                                                                      .withOpacity(
                                                                        0.5,
                                                                      ),
                                                                );
                                                              },
                                                            ),
                                                          )
                                                          : Icon(
                                                            Icons
                                                                .shopping_bag_outlined,
                                                            size: 16,
                                                            color: Colors.blue
                                                                .withOpacity(
                                                                  0.5,
                                                                ),
                                                          ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        product.name,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                      SizedBox(height: 2),
                                                      Text(
                                                        '${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(product.price)}',
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    if (mounted) {
                                      Future.microtask(() {
                                        setState(() {
                                          _selectedProductId = value;
                                        });
                                      });
                                    }
                                  },
                                  validator:
                                      (value) =>
                                          value == null
                                              ? 'Please select a product'
                                              : null,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _startDateController,
                              label: 'Start Date',
                              readOnly: true,
                              onTap:
                                  () => _selectDate(
                                    context,
                                    _startDateController,
                                  ),
                              prefixIcon: Icons.calendar_today,
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true
                                          ? 'Please select start date'
                                          : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _endDateController,
                              label: 'End Date',
                              readOnly: true,
                              onTap:
                                  () =>
                                      _selectDate(context, _endDateController),
                              prefixIcon: Icons.event,
                              validator: _validateEndDate,
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _minQuantityController,
                              label: 'Min Quantity',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.remove_circle_outline,
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true
                                          ? 'Please enter min quantity'
                                          : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildTextField(
                              controller: _maxQuantityController,
                              label: 'Max Quantity',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.add_circle_outline,
                              validator:
                                  (value) =>
                                      value?.isEmpty ?? true
                                          ? 'Please enter max quantity'
                                          : null,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Update',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(Icons.edit, color: Colors.white, size: 30),
                ),
              ),
            ),
          ],
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
    super.dispose();
  }
}

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  await Future.delayed(Duration.zero);

  DateTime? date;
  try {
    date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child ?? Container(),
        );
      },
    );
  } catch (e) {
    print('Error showing date picker: $e');
    return null;
  }

  if (date == null) return null;

  await Future.delayed(Duration.zero);

  TimeOfDay? time;
  try {
    time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child ?? Container(),
        );
      },
    );
  } catch (e) {
    print('Error showing time picker: $e');
    return null;
  }

  if (time == null) return null;

  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
