import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_radio_button.dart';
import '../widgets/custom_checkbox.dart';
import '../services/api_service.dart';

class RetailScreen extends StatefulWidget {
  const RetailScreen({super.key});

  @override
  State<RetailScreen> createState() => _RetailScreenState();
}

class _RetailScreenState extends State<RetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _budgetController = TextEditingController();
  final _quantityController = TextEditingController();
  final _deliveryDateController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _budgetController.dispose();
    _quantityController.dispose();
    _deliveryDateController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      
      final response = await ApiService.submitRetailRequest(
        retailCategory: provider.selectedRetailCategory,
        country: provider.selectedCountry,
        state: provider.selectedState,
        city: provider.selectedRetailCity,
        deliveryDate: _deliveryDateController.text,
        quantity: int.tryParse(_quantityController.text),
        brandPreference: provider.selectedBrandPreference,
        qualityPreference: provider.selectedQualityPreference,
        budget: double.tryParse(_budgetController.text),
        currency: provider.selectedCurrency,
        is24HourResponse: provider.is24HourResponse,
      );

      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        _showSubmitDialog(context, response);
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      if (mounted) {
        _showErrorDialog(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retail & Shopping'),
        backgroundColor: const Color(0xFF1976D2),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Form Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          'Tell Us Your Retail Requirements',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Retail Category
                        CustomDropdown(
                          label: 'Retail Category',
                          value: provider.selectedRetailCategory,
                          items: ['Electronics', 'Fashion', 'Home & Garden', 'Sports', 'Beauty', 'Books', 'Toys', 'Automotive'],
                          onChanged: (value) => provider.setRetailCategory(value!),
                        ),
                        const SizedBox(height: 20),

                        // Country
                        CustomDropdown(
                          label: 'Country',
                          value: provider.selectedCountry,
                          items: ['India', 'China', 'Japan', 'USA', 'UK', 'Germany', 'France'],
                          onChanged: (value) => provider.setCountry(value!),
                        ),
                        const SizedBox(height: 20),

                        // State
                        CustomDropdown(
                          label: 'State/Province',
                          value: provider.selectedState,
                          items: ['Maharashtra', 'Delhi', 'Karnataka', 'Tamil Nadu', 'Gujarat', 'Rajasthan'],
                          onChanged: (value) => provider.setState(value!),
                        ),
                        const SizedBox(height: 20),

                        // City
                        CustomDropdown(
                          label: 'City',
                          value: provider.selectedRetailCity,
                          items: ['Delhi', 'Bangalore', 'Chennai', 'Ahmedabad', 'Jaipur', 'Surat'],
                          onChanged: (value) => provider.setRetailCity(value!),
                        ),
                        const SizedBox(height: 20),

                        // Delivery Date
                        const Text(
                          'Preferred Delivery Date',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _deliveryDateController,
                          decoration: InputDecoration(
                            hintText: 'Enter preferred delivery date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF1976D2)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter delivery date';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Quantity
                        const Text(
                          'Quantity Required',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(
                            hintText: 'Enter quantity',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Color(0xFF1976D2)),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter quantity';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Brand Preference
                        const Text(
                          'Brand Preference',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildBrandOptions(provider),
                        const SizedBox(height: 24),

                        // Quality Preference
                        const Text(
                          'Quality Preference',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            CustomRadioButton(
                              label: 'Premium',
                              value: 'Premium',
                              groupValue: provider.selectedQualityPreference,
                              onChanged: (value) => provider.setQualityPreference(value!),
                              isSelected: provider.selectedQualityPreference == 'Premium',
                            ),
                            const SizedBox(width: 20),
                            CustomRadioButton(
                              label: 'Standard',
                              value: 'Standard',
                              groupValue: provider.selectedQualityPreference,
                              onChanged: (value) => provider.setQualityPreference(value!),
                              isSelected: provider.selectedQualityPreference == 'Standard',
                            ),
                            const SizedBox(width: 20),
                            CustomRadioButton(
                              label: 'Budget',
                              value: 'Budget',
                              groupValue: provider.selectedQualityPreference,
                              onChanged: (value) => provider.setQualityPreference(value!),
                              isSelected: provider.selectedQualityPreference == 'Budget',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Budget
                        const Text(
                          'Budget',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _budgetController,
                                decoration: InputDecoration(
                                  hintText: 'Amount',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Color(0xFF1976D2)),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter budget amount';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid amount';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: 80,
                              child: CustomDropdown(
                                label: '',
                                value: provider.selectedCurrency,
                                items: ['INR', 'USD', 'EUR', 'GBP'],
                                onChanged: (value) => provider.setCurrency(value!),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Response Time
                        const Text(
                          'Get offer within (optional)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        CustomCheckbox(
                          label: '24 hours',
                          value: provider.is24HourResponse,
                          onChanged: (value) => provider.set24HourResponse(value!),
                          subtitle: 'Needs 1 extra points',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Normal response time is within 2days',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitForm,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Submit Request',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrandOptions(AppProvider provider) {
    final brandPreferences = [
      {'name': 'Any Brand', 'icon': Icons.all_inclusive, 'color': Colors.grey},
      {'name': 'Premium Brands', 'icon': Icons.star, 'color': Colors.amber},
      {'name': 'Local Brands', 'icon': Icons.location_on, 'color': Colors.green},
      {'name': 'International', 'icon': Icons.flight, 'color': Colors.blue},
      {'name': 'No Preference', 'icon': Icons.check_circle, 'color': Colors.purple},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: brandPreferences.map((brand) {
        final isSelected = provider.selectedBrandPreference == brand['name'];
        return GestureDetector(
          onTap: () => provider.setBrandPreference(brand['name'] as String),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? const Color(0xFF1976D2) : Colors.grey.shade300,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  brand['icon'] as IconData,
                  color: isSelected ? Colors.white : brand['color'] as Color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  brand['name'] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showSubmitDialog(BuildContext context, Map<String, dynamic> response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your retail requirements have been submitted successfully.'),
            const SizedBox(height: 16),
            Text(
              'Request ID: ${response['id']}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            Text(
              'Status: ${response['status']}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to home screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Failed to submit request: $error'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
