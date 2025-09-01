@echo off
echo Setting up Mobile App Project...
echo.

echo 1. Setting up Flutter Frontend...
cd frontend
flutter pub get
echo Flutter dependencies installed!
echo.

echo 2. Setting up Node.js Backend...
cd ..\backend
npm install
echo Backend dependencies installed!
echo.

echo 3. Starting Backend Server...
start "Backend Server" cmd /k "npm start"
echo Backend server starting on http://localhost:3000
echo.

echo 4. Setup Complete!
echo.
echo To run the Flutter app:
echo cd frontend
echo flutter run
echo.
echo To stop the backend server, close the backend command window.
echo.
pause
