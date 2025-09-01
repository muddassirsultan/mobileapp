import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_radio_button.dart';
import '../widgets/custom_checkbox.dart';
import '../services/api_service.dart';

class BanquetVenuesScreen extends StatefulWidget {
  const BanquetVenuesScreen({super.key});

  @override
  State<BanquetVenuesScreen> createState() => _BanquetVenuesScreenState();
}

class _BanquetVenuesScreenState extends State<BanquetVenuesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberOfAdultsController = TextEditingController();
  final _budgetController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _numberOfAdultsController.dispose();
    _budgetController.dispose();
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
      
      final response = await ApiService.submitVenueRequest(
        eventType: provider.selectedEventType,
        country: provider.selectedCountry,
        state: provider.selectedState,
        city: provider.selectedCity,
        eventDates: ['1st March 2025', '2nd March 2025'], // Hardcoded for now
        numberOfAdults: int.tryParse(_numberOfAdultsController.text),
        cateringPreference: provider.selectedCatering,
        cuisines: [provider.selectedCuisine],
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
        title: const Text('Banquets & Venues'),
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
                          'Tell Us Your Venue Requirements',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Event Type
                        CustomDropdown(
                          label: 'Event Type',
                          value: provider.selectedEventType,
                          items: ['Wedding', 'Anniversary', 'Corporate event', 'Other Party'],
                          onChanged: (value) => provider.setEventType(value!),
                        ),
                        const SizedBox(height: 20),

                        // Country
                        CustomDropdown(
                          label: 'Country',
                          value: provider.selectedCountry,
                          items: ['India', 'China', 'Japan', 'Russia'],
                          onChanged: (value) => provider.setCountry(value!),
                        ),
                        const SizedBox(height: 20),

                        // State
                        CustomDropdown(
                          label: 'State',
                          value: provider.selectedState,
                          items: ['Maharashtra', 'Delhi', 'Karnataka', 'Tamil Nadu'],
                          onChanged: (value) => provider.setState(value!),
                        ),
                        const SizedBox(height: 20),

                        // City
                        CustomDropdown(
                          label: 'City',
                          value: provider.selectedCity,
                          items: ['Powai', 'Mumbai', 'Pune', 'Nagpur', 'Thane'],
                          onChanged: (value) => provider.setCity(value!),
                        ),
                        const SizedBox(height: 20),

                        // Event Dates
                        const Text(
                          'Event Dates',
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
                              child: _buildDateField('1st March 2025'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildDateField('2nd March 2025'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            // Add more dates functionality
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF1976D2),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '+ add more dates',
                                style: TextStyle(
                                  color: const Color(0xFF1976D2),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Number of Adults
                        const Text(
                          'Number of Adults',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _numberOfAdultsController,
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
                              return 'Please enter number of adults';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Catering Preference
                        const Text(
                          'Catering Preference',
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
                              label: 'Non-veg',
                              value: 'Non-veg',
                              groupValue: provider.selectedCatering,
                              onChanged: (value) => provider.setCatering(value!),
                              isSelected: provider.selectedCatering == 'Non-veg',
                            ),
                            const SizedBox(width: 20),
                            CustomRadioButton(
                              label: 'Veg',
                              value: 'Veg',
                              groupValue: provider.selectedCatering,
                              onChanged: (value) => provider.setCatering(value!),
                              isSelected: provider.selectedCatering == 'Veg',
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Cuisines
                        const Text(
                          'Please select your Cuisines',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildCuisineOptions(provider),
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

  Widget _buildDateField(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              date,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
          const Icon(
            Icons.calendar_today,
            color: Colors.grey,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildCuisineOptions(AppProvider provider) {
    final cuisines = [
      {'name': 'Indian', 'icon': Icons.restaurant, 'color': Colors.orange},
      {'name': 'Italian', 'icon': Icons.local_pizza, 'color': Colors.red},
      {'name': 'Asian', 'icon': Icons.ramen_dining, 'color': Colors.green},
      {'name': 'Mexican', 'icon': Icons.restaurant_menu, 'color': Colors.yellow},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: cuisines.map((cuisine) {
        final isSelected = provider.selectedCuisine == cuisine['name'];
        return GestureDetector(
          onTap: () => provider.setCuisine(cuisine['name'] as String),
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
                  cuisine['icon'] as IconData,
                  color: isSelected ? Colors.white : cuisine['color'] as Color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  cuisine['name'] as String,
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
            const Text('Your venue requirements have been submitted successfully.'),
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
