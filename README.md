# 🎬 Movies App

A simple iOS application that displays a list of popular movies using [The Movie Database API (TMDB)](https://developers.themoviedb.org/3/).  
The app allows users to search, sort, and view detailed information about movies, including trailers and posters.

---

## 📌 Features

- 🔹 Display popular movies sorted by popularity (descending)  
- 🔹 Infinite scroll pagination 
- 🔹 Pull-to-refresh to reload from the first page  
- 🔹 Movie search by title  
- 🔹 Sort options (popularity, rating, release date) via native `ActionSheet`  
- 🔹 Movie details screen with:
  - Poster in fixed size  
  - Title, release year, genres, description, rating  
  - Trailer button (if available)  
  - Full-screen poster view with zoom & scroll  
- 🔹 Error handling with native alerts  
- 🔹 Offline mode support  
- 🔹 Empty states for no results

---

## 🧱 Tech Stack

- **Language:** Swift  
- **Minimum iOS:** 15.0  
- **UI:** UIKit + XIBs + Auto Layout (no storyboards)  
- **Networking:** Alamofire
- **ImagesLoading:** Kingfisher
- **DependencyInjection:** Swinject

---

## 🌐 API

- Base: [TMDB API](https://developers.themoviedb.org/3/)  
- Endpoints used:
  - `/movie/popular`
  - `/search/movie`
  - `/movie/{movie_id}`
  - `/movie/{movie_id}/videos`


## 🧪 How to Run

1. Clone the repository
   ```bash
   git clone https://github.com/korolmarta/Movies.git
2. Open the project in Xcode 15+
3. Add your TMDB API key to AppConfig.xcconfig
4. Build & run the project



https://github.com/user-attachments/assets/99cac293-c52b-407d-86cd-3b77b74faf6c



https://github.com/user-attachments/assets/e61ead42-2b81-4989-a7a3-9e50329dbeb2


