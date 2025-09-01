import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_radio_button.dart';
import '../widgets/custom_checkbox.dart';
import '../services/api_service.dart';

class TravelStayScreen extends StatefulWidget {
  const TravelStayScreen({super.key});

  @override
  State<TravelStayScreen> createState() => _TravelStayScreenState();
}

class _TravelStayScreenState extends State<TravelStayScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberOfTravelersController = TextEditingController();
  final _budgetController = TextEditingController();
  final _checkInDateController = TextEditingController();
  final _checkOutDateController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _numberOfTravelersController.dispose();
    _budgetController.dispose();
    _checkInDateController.dispose();
    _checkOutDateController.dispose();
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
      
      final response = await ApiService.submitTravelRequest(
        travelType: provider.selectedTravelType,
        country: provider.selectedCountry,
        state: provider.selectedState,
        city: provider.selectedTravelCity,
        checkInDate: _checkInDateController.text,
        checkOutDate: _checkOutDateController.text,
        numberOfTravelers: int.tryParse(_numberOfTravelersController.text),
        accommodationType: provider.selectedAccommodationType,
        travelClass: provider.selectedTravelClass,
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
        title: const Text('Travel & Stay'),
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
                          'Tell Us Your Travel & Stay Requirements',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Travel Type
                        CustomDropdown(
                          label: 'Travel Type',
                          value: provider.selectedTravelType,
                          items: ['Business Trip', 'Vacation', 'Honeymoon', 'Family Trip', 'Solo Travel'],
                          onChanged: (value) => provider.setTravelType(value!),
                        ),
                        const SizedBox(height: 20),

                        // Country
                        CustomDropdown(
                          label: 'Destination Country',
                          value: provider.selectedCountry,
                          items: ['India', 'Thailand', 'Singapore', 'Maldives', 'Dubai', 'Europe', 'USA'],
                          onChanged: (value) => provider.setCountry(value!),
                        ),
                        const SizedBox(height: 20),

                        // State
                        CustomDropdown(
                          label: 'State/Province',
                          value: provider.selectedState,
                          items: ['Maharashtra', 'Delhi', 'Karnataka', 'Tamil Nadu', 'Kerala'],
                          onChanged: (value) => provider.setState(value!),
                        ),
                        const SizedBox(height: 20),

                        // City
                        CustomDropdown(
                          label: 'City',
                          value: provider.selectedTravelCity,
                          items: ['Delhi', 'Bangalore', 'Chennai', 'Kochi', 'Goa', 'Shimla'],
                          onChanged: (value) => provider.setTravelCity(value!),
                        ),
                        const SizedBox(height: 20),

                        // Travel Dates
                        const Text(
                          'Travel Dates',
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
                              child: _buildDateField('Check-in Date', _checkInDateController),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDateField('Check-out Date', _checkOutDateController),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Number of Travelers
                        const Text(
                          'Number of Travelers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _numberOfTravelersController,
                          decoration: InputDecoration(
                            hintText: 'Enter number',
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
                              return 'Please enter number of travelers';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Accommodation Type
                        const Text(
                          'Accommodation Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAccommodationOptions(provider),
                        const SizedBox(height: 24),

                        // Travel Class
                        const Text(
                          'Travel Class Preference',
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
                              label: 'Economy',
                              value: 'Economy',
                              groupValue: provider.selectedTravelClass,
                              onChanged: (value) => provider.setTravelClass(value!),
                              isSelected: provider.selectedTravelClass == 'Economy',
                            ),
                            const SizedBox(width: 20),
                            CustomRadioButton(
                              label: 'Business',
                              value: 'Business',
                              groupValue: provider.selectedTravelClass,
                              onChanged: (value) => provider.setTravelClass(value!),
                              isSelected: provider.selectedTravelClass == 'Business',
                            ),
                            const SizedBox(width: 20),
                            CustomRadioButton(
                              label: 'First Class',
                              value: 'First Class',
                              groupValue: provider.selectedTravelClass,
                              onChanged: (value) => provider.setTravelClass(value!),
                              isSelected: provider.selectedTravelClass == 'First Class',
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

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
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
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildAccommodationOptions(AppProvider provider) {
    final accommodationTypes = [
      {'name': 'Hotel', 'icon': Icons.hotel, 'color': Colors.blue},
      {'name': 'Resort', 'icon': Icons.beach_access, 'color': Colors.orange},
      {'name': 'Villa', 'icon': Icons.home, 'color': Colors.green},
      {'name': 'Apartment', 'icon': Icons.apartment, 'color': Colors.purple},
      {'name': 'Hostel', 'icon': Icons.bed, 'color': Colors.red},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: accommodationTypes.map((type) {
        final isSelected = provider.selectedAccommodationType == type['name'];
        return GestureDetector(
          onTap: () => provider.setAccommodationType(type['name'] as String),
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
                  type['icon'] as IconData,
                  color: isSelected ? Colors.white : type['color'] as Color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  type['name'] as String,
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
            const Text('Your travel & stay requirements have been submitted successfully.'),
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
