# 🦖 Yoshi Companion App

> "Yoshi! Wa-hoo!" 🥚

A comforting, AI-powered companion app featuring everyone's favorite green dinosaur, **Yoshi**!  
Built with **FastAPI**, **Ollama**, and **Flutter**.

## ✨ Features

- **🦕 Talk to Yoshi**: A fully conversational agent that mimics Yoshi's personality (cheerful, supportive, third-person speech).
- **🧠 Local AI Brain**: Powered by **Llama 3.2** (via Ollama) running locally on your machine. No cloud API keys needed!
- **📚 Smart Knowledge (RAG)**: Yoshi knows about his world! He can answer questions about _Yoshi's Island_, _Woolly World_, _Crafted World_, and more.
- **📱 Beautiful Flutter App**: A polished, "Yoshi Green" themed mobile interface with animations, skeleton loading, and daily quotes.
- **🛡️ Safety First**: Includes robust prompt injection defenses to keep Yoshi always in character.

---

## 🏗️ Architecture

The project is divided into two main parts:

### 1. Backend (`/backend`)

- **Framework**: Python FastAPI.
- **AI Engine**: [Ollama](https://ollama.com/) (running `llama3.2`).
- **Orchestration**: Custom Multi-Agent system (`YoshiAgent` + `LibrarianAgent`).
- **Database**: DuckDB (for vector search and RAG).
- **Caching**: DiskCache to remember responses.

### 2. Frontend (`/frontend_flutter`)

- **Framework**: Flutter (Dart).
- **UI**: Material Design 3 with custom "Yoshi Theme" (Green/Orange/White).
- **Navigation**: Bottom Tabs (Home, Info, Facts, Chat).
- **State**: Provider.

---

## 🚀 Getting Started

### Prerequisites

- **Python 3.10+**
- **Flutter SDK**
- **Ollama** installed and running (`ollama serve`).

### 1️⃣ Setup Backend

1.  Navigate to the project root:
    ```bash
    cd backend
    ```
2.  Create and activate a virtual environment:
    ```bash
    python -m venv venv
    .\venv\Scripts\activate
    ```
3.  Install dependencies:
    ```bash
    pip install -r requirements.txt
    ```
4.  Start the Server:
    ```bash
    uvicorn backend.main:app --reload
    ```
    _You should see "Yoshi System Booting... 🥚"_

### 2️⃣ Setup Frontend

1.  Open a new terminal and navigate to the flutter folder:
    ```bash
    cd frontend_flutter
    ```
2.  Get dependencies:
    ```bash
    flutter pub get
    ```
3.  Run the App (ensure you have an emulator or Windows enabled):
    ```bash
    flutter run -d windows
    # or flutter run -d android
    ```

---

## 🛠️ Usage

- **Home Tab**: Check the "Thought of the Day" and see the welcoming Yoshi.
- **Info/Facts Tab**: Read lore about Yoshi's games and history.
- **Chat Tab**: Type a message!
  - _"Tell me a story!"_ -> Yoshi will generate a creative story.
  - _"I'm sad..."_ -> Yoshi will offer comfort.
  - _"Who is Poochy?"_ -> Yoshi will look up info in his Knowledge Base.

---

## 📂 Project Structure

```
yoshi/
├── backend/
│   ├── agents/          # AI Logic (Yoshi, Orchestrator)
│   ├── knowledge/       # Markdown files (Lore, Facts)
│   ├── main.py          # FastAPI Entry Point
│   ├── brain.py         # DuckDB & RAG Logic
│   └── persona.py       # System Prompts
│
├── frontend_flutter/
│   ├── lib/
│   │   ├── screens/     # UI Pages (Chat, Home, etc.)
│   │   ├── services/    # API Integration
│   │   └── styles/      # Theme & Colors
│   └── pubspec.yaml     # Flutter Config
│
└── README.md            # This file!
```

## 📝 Credits

Created with ❤️ (and lots of fruit) for a safer, happier world.
_"Yoshi!"_
