import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String _selectedEventType = 'Wedding';
  String _selectedCountry = 'India';
  String _selectedState = 'Maharashtra';
  String _selectedCity = 'Powai';
  String _selectedCatering = 'Non-veg';
  String _selectedCuisine = 'Indian';
  String _selectedCurrency = 'INR';
  bool _is24HourResponse = false;
  
  
  String _selectedTravelType = 'Business Trip';
  String _selectedAccommodationType = 'Hotel';
  String _selectedTravelClass = 'Economy';
  String _selectedTravelCity = 'Delhi';
  
  
  String _selectedRetailCategory = 'Electronics';
  String _selectedBrandPreference = 'Any Brand';
  String _selectedQualityPreference = 'Standard';
  String _selectedRetailCity = 'Delhi';
  

  String get selectedEventType => _selectedEventType;
  String get selectedCountry => _selectedCountry;
  String get selectedState => _selectedState;
  String get selectedCity => _selectedCity;
  String get selectedCatering => _selectedCatering;
  String get selectedCuisine => _selectedCuisine;
  String get selectedCurrency => _selectedCurrency;
  bool get is24HourResponse => _is24HourResponse;
  
 
  String get selectedTravelType => _selectedTravelType;
  String get selectedAccommodationType => _selectedAccommodationType;
  String get selectedTravelClass => _selectedTravelClass;
  String get selectedTravelCity => _selectedTravelCity;
  
  
  String get selectedRetailCategory => _selectedRetailCategory;
  String get selectedBrandPreference => _selectedBrandPreference;
  String get selectedQualityPreference => _selectedQualityPreference;
  String get selectedRetailCity => _selectedRetailCity;

 
  void setEventType(String value) {
    _selectedEventType = value;
    notifyListeners();
  }

  void setCountry(String value) {
    _selectedCountry = value;
    notifyListeners();
  }

  void setState(String value) {
    _selectedState = value;
    notifyListeners();
  }

  void setCity(String value) {
    _selectedCity = value;
    notifyListeners();
  }

  void setCatering(String value) {
    _selectedCatering = value;
    notifyListeners();
  }

  void setCuisine(String value) {
    _selectedCuisine = value;
    notifyListeners();
  }

  void setCurrency(String value) {
    _selectedCurrency = value;
    notifyListeners();
  }

  void set24HourResponse(bool value) {
    _is24HourResponse = value;
    notifyListeners();
  }
  
  
  void setTravelType(String value) {
    _selectedTravelType = value;
    notifyListeners();
  }
  
  void setAccommodationType(String value) {
    _selectedAccommodationType = value;
    notifyListeners();
  }
  
  void setTravelClass(String value) {
    _selectedTravelClass = value;
    notifyListeners();
  }
  
  void setTravelCity(String value) {
    _selectedTravelCity = value;
    notifyListeners();
  }
  
  
  void setRetailCategory(String value) {
    _selectedRetailCategory = value;
    notifyListeners();
  }
  
  void setBrandPreference(String value) {
    _selectedBrandPreference = value;
    notifyListeners();
  }
  
  void setQualityPreference(String value) {
    _selectedQualityPreference = value;
    notifyListeners();
  }
  
  void setRetailCity(String value) {
    _selectedRetailCity = value;
    notifyListeners();
  }
}
