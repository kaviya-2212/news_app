# 📰 Flutter News App

A simple news application built with **Flutter**, displaying top headlines fetched from the News API. The app includes:

- 📲 Login screen with static credentials.
- 🏠 Home screen with top news articles.
- 🔖 Bookmark functionality (locally saved).
- 💾 Login session storage to avoid re-login.

---

## 🚀 Setup Instructions

1. **Clone the repository:**
   git clone https://github.com/your-username/flutter-news-app.git
   cd flutter-news-app
   Install dependencies:
   flutter pub get
   Run the app:
   flutter run
   Login Credentials:

Email: admin@gmail.com

Password: Admin@123

🖼️ Screenshots
⚠️ Add your actual screenshots in the screenshots/ folder and update the links below.

Login Page Home Page Bookmarked Articles
![alt text](Screenshot_1748365213.png)![alt text](Screenshot_1748365215.png)
🧱 Architecture Overview
This app uses a simple StatefulWidget-based architecture for better readability and ease of learning for beginners:

LoginPage: Stateless login using TextEditingController and validation.

NewsPage: Fetches top headlines using http and manages local bookmark state.

Session Handling: Uses SharedPreferences to store login and bookmark state locally.

Navigation: Powered by get package for smooth page transitions.

📦 Packages Used
Package Reason
http To fetch news data from News API
get For simple state management and navigation
shared_preferences To store login session and bookmarks locally
intl To format published dates into readable strings

✅ Features
Login once and stay signed in.

Read top headlines from the US.

Tap on a news card to view detailed content.

Bookmark/unbookmark articles using a toggle button.

Pull-to-refresh news list.
