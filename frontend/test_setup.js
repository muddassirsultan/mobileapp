const http = require('http');

// Test the backend API endpoints
const testEndpoints = async () => {
  console.log('Testing Mobile App Backend API...\n');

  // Test health endpoint
  try {
    const healthResponse = await makeRequest('GET', '/api/health');
    console.log('✅ Health Check:', healthResponse.message);
  } catch (error) {
    console.log('❌ Health Check Failed:', error.message);
  }

  // Test categories endpoint
  try {
    const categoriesResponse = await makeRequest('GET', '/api/categories');
    console.log('✅ Categories:', `${categoriesResponse.data.length} categories found`);
    categoriesResponse.data.forEach(cat => {
      console.log(`   - ${cat.name}`);
    });
  } catch (error) {
    console.log('❌ Categories Failed:', error.message);
  }

  // Test venue request submission
  try {
    const venueRequest = {
      eventType: 'Wedding',
      country: 'India',
      state: 'Maharashtra',
      city: 'Mumbai',
      eventDates: ['1st March 2025'],
      numberOfAdults: 100,
      cateringPreference: 'Non-veg',
      cuisines: ['Indian'],
      budget: 50000,
      currency: 'INR',
      is24HourResponse: false
    };

    const submitResponse = await makeRequest('POST', '/api/venue-requests', venueRequest);
    console.log('✅ Venue Request Submitted:', submitResponse.message);
    console.log(`   Request ID: ${submitResponse.data.id}`);
    console.log(`   Status: ${submitResponse.data.status}`);
  } catch (error) {
    console.log('❌ Venue Request Failed:', error.message);
  }

  // Test getting venue requests
  try {
    const requestsResponse = await makeRequest('GET', '/api/venue-requests');
    console.log('✅ Venue Requests:', `${requestsResponse.data.length} requests found`);
  } catch (error) {
    console.log('❌ Get Venue Requests Failed:', error.message);
  }

  console.log('\n🎉 API Testing Complete!');
};

// Helper function to make HTTP requests
const makeRequest = (method, path, data = null) => {
  return new Promise((resolve, reject) => {
    const options = {
      hostname: 'localhost',
      port: 3000,
      path: path,
      method: method,
      headers: {
        'Content-Type': 'application/json',
      },
    };

    if (data) {
      const postData = JSON.stringify(data);
      options.headers['Content-Length'] = Buffer.byteLength(postData);
    }

    const req = http.request(options, (res) => {
      let responseData = '';
      
      res.on('data', (chunk) => {
        responseData += chunk;
      });

      res.on('end', () => {
        try {
          const parsed = JSON.parse(responseData);
          if (res.statusCode >= 200 && res.statusCode < 300) {
            resolve(parsed);
          } else {
            reject(new Error(parsed.message || 'Request failed'));
          }
        } catch (error) {
          reject(new Error('Invalid JSON response'));
        }
      });
    });

    req.on('error', (error) => {
      reject(error);
    });

    if (data) {
      req.write(JSON.stringify(data));
    }

    req.end();
  });
};

// Run tests if backend is available
console.log('Checking if backend is running...');
makeRequest('GET', '/api/health')
  .then(() => {
    console.log('Backend is running! Starting tests...\n');
    testEndpoints();
  })
  .catch(() => {
    console.log('❌ Backend is not running. Please start the backend server first:');
    console.log('   cd backend');
    console.log('   npm start');
  });
