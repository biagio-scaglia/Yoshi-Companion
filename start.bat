@echo off
echo Starting Yoshi System... 🦕

echo Starting Backend...
start "Yoshi Backend" cmd /k "cd backend && call venv\Scripts\activate && uvicorn backend.main:app --reload"

echo Starting Frontend (Chrome)...
start "Yoshi Frontend" cmd /k "cd frontend_flutter && flutter run -d chrome"

echo All systems go! Wa-hoo! 🥚
