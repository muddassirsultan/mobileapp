# Assets Directory

This directory contains images and other assets for the mobile app.

## Category Images

Place the following images in this directory for the category cards:

- `travel_stay.jpg` - Image for Travel & Stay category
- `banquet_venues.jpg` - Image for Banquets & Venues category  
- `retail_stores.jpg` - Image for Retail stores & Shops category

## Image Requirements

- Recommended size: 400x300 pixels
- Format: JPG or PNG
- File size: Keep under 500KB for optimal performance

## Current Implementation

The app currently uses colored backgrounds with icons as placeholders for the category cards. To use actual images:

1. Add your images to this directory
2. Update the `CategoryCard` widget in `lib/widgets/category_card.dart`
3. Replace the colored background with `Image.asset()` widgets

## Example Usage

```dart
// In category_card.dart
Container(
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    image: DecorationImage(
      image: AssetImage(category.imagePath),
      fit: BoxFit.cover,
    ),
  ),
  // ... rest of the widget
)
```
