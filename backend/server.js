const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// In-memory storage (replace with database in production)
let venueRequests = [];
let categories = [
  {
    id: '1',
    name: 'Travel & Stay',
    imagePath: '/images/travel_stay.jpg',
    route: '/travel-stay',
    icon: 'flight'
  },
  {
    id: '2',
    name: 'BANQUETS & VENUES',
    imagePath: '/images/banquet_venues.jpg',
    route: '/banquet-venues',
    icon: 'celebration'
  },
  {
    id: '3',
    name: 'Retail stores & Shops',
    imagePath: '/images/retail_stores.jpg',
    route: '/retail-stores',
    icon: 'shopping_bag'
  }
];

// Routes

// Get all categories
app.get('/api/categories', (req, res) => {
  try {
    res.json({
      success: true,
      data: categories
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching categories',
      error: error.message
    });
  }
});

// Get category by ID
app.get('/api/categories/:id', (req, res) => {
  try {
    const category = categories.find(cat => cat.id === req.params.id);
    if (!category) {
      return res.status(404).json({
        success: false,
        message: 'Category not found'
      });
    }
    res.json({
      success: true,
      data: category
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching category',
      error: error.message
    });
  }
});

// Submit venue request
app.post('/api/venue-requests', (req, res) => {
  try {
    const {
      eventType,
      country,
      state,
      city,
      eventDates,
      numberOfAdults,
      cateringPreference,
      cuisines,
      budget,
      currency,
      is24HourResponse
    } = req.body;

    // Validation
    if (!eventType || !country || !state || !city) {
      return res.status(400).json({
        success: false,
        message: 'Required fields are missing'
      });
    }

    const newRequest = {
      id: Date.now().toString(),
      eventType,
      country,
      state,
      city,
      eventDates: eventDates || [],
      numberOfAdults: numberOfAdults || 0,
      cateringPreference,
      cuisines: cuisines || [],
      budget: budget || 0,
      currency: currency || 'INR',
      is24HourResponse: is24HourResponse || false,
      createdAt: new Date().toISOString(),
      status: 'pending'
    };

    venueRequests.push(newRequest);

    res.status(201).json({
      success: true,
      message: 'Venue request submitted successfully',
      data: newRequest
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error submitting venue request',
      error: error.message
    });
  }
});

// Get all venue requests
app.get('/api/venue-requests', (req, res) => {
  try {
    res.json({
      success: true,
      data: venueRequests
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching venue requests',
      error: error.message
    });
  }
});

// Get venue request by ID
app.get('/api/venue-requests/:id', (req, res) => {
  try {
    const request = venueRequests.find(req => req.id === req.params.id);
    if (!request) {
      return res.status(404).json({
        success: false,
        message: 'Venue request not found'
      });
    }
    res.json({
      success: true,
      data: request
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching venue request',
      error: error.message
    });
  }
});

// Update venue request status
app.patch('/api/venue-requests/:id/status', (req, res) => {
  try {
    const { status } = req.body;
    const requestIndex = venueRequests.findIndex(req => req.id === req.params.id);
    
    if (requestIndex === -1) {
      return res.status(404).json({
        success: false,
        message: 'Venue request not found'
      });
    }

    venueRequests[requestIndex].status = status;
    venueRequests[requestIndex].updatedAt = new Date().toISOString();

    res.json({
      success: true,
      message: 'Venue request status updated successfully',
      data: venueRequests[requestIndex]
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating venue request status',
      error: error.message
    });
  }
});

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'Server is running',
    timestamp: new Date().toISOString()
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({
    success: false,
    message: 'Something went wrong!',
    error: err.message
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({
    success: false,
    message: 'Route not found'
  });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`API endpoints available at http://localhost:${PORT}/api`);
});
