# 📱 Video Feed Test Project

A Flutter test project implementing a **TikTok/Reels-style vertical video feed** powered by the [интересно и точка](https://interesnoitochka.ru) API.  
The app demonstrates API integration, vertical paging, video playback, and smooth UI overlays.

---

## ✨ Features
- Vertical **scrollable video feed** with peeking effect (next/previous video partially visible).
- **Preview autoplay** (muted, starts after delay).
- Tap-to-open full **video player with sound** and animated transition.
- Overlay with metadata (hashtags, location, views, duration).
- API integration with HLS video streaming.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>= 3.19)
- Xcode / Android Studio for iOS or Android builds

## 🛠 Tech Stack
- Flutter (UI framework)
- video_player (HLS playback)
- http (API requests)
- PageView (vertical scrolling feed)
## 📡 API References
- Video recommendations: 
- GET /api/v1/videos/recommendations
- HLS playlist:
- GET /api/v1/videos/video/{video_id}/hls/playlist.m3u8