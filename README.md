# LifeTimer - 1356 Day Challenge

> A gamified life countdown app where users create a bucket list and start an irreversible 1356-day journey to achieve their goals.

## 🎯 Overview

LifeTimer is a production-ready Flutter mobile application that helps users achieve their life goals through a focused 1356-day countdown challenge. Users create a bucket list of up to 20 goals, and once they start their countdown, it cannot be stopped, paused, or extended - creating real commitment and motivation.

**Current Status**: 🚀 Ready for Beta Testing & App Store Submission  
**Version**: 1.0.0 (Pre-release)  
**Platform**: iOS & Android

---

## ✨ Key Features

### Core Experience
- 🔐 **Secure Authentication** - Email, Google, and Apple OAuth
- 📝 **Bucket List Creation** - Up to 20 life goals with detailed tracking
- ⏰ **1356-Day Countdown** - Irreversible timer with real-time updates
- 📊 **Progress Tracking** - Milestones, steps, and achievement system
- 👤 **Profile Management** - Customizable profiles with avatars

### Advanced Features
- 🗺️ **Location Support** - GPS and map integration for location-based goals
- 🖼️ **Image Integration** - Upload photos or search Unsplash/Pexels
- 📈 **Analytics & Insights** - Charts and progress visualization
- 🔔 **Smart Notifications** - Daily, weekly, and milestone reminders
- 💾 **Offline Support** - Full functionality with intelligent caching
- 🎨 **Customization** - Light/dark themes, 12/24h formats

### Social Features
- 🌐 **Public/Private Profiles** - Control your privacy
- 📱 **Social Feed** - Share milestones and achievements
- 🏆 **Leaderboards** - Compete on goals completed and streaks
- 👥 **Following System** - Connect with other users
- 🏅 **Achievements System** - Earn badges for accomplishments

---

## 🛠 Tech Stack

### Frontend
- **Framework**: Flutter 3.10+
- **Language**: Dart 3.0+
- **State Management**: Riverpod
- **Navigation**: Go Router
- **UI Components**: Material Design 3

### Backend
- **Provider**: Supabase
- **Database**: PostgreSQL with RLS
- **Authentication**: Supabase Auth
- **Storage**: Supabase Storage
- **Realtime**: Supabase Realtime

### Key Libraries
- `flutter_riverpod` - State management
- `supabase_flutter` - Backend integration
- `go_router` - Navigation
- `fl_chart` - Analytics charts
- `cached_network_image` - Image caching
- `geolocator` - Location services
- `google_maps_flutter` - Maps
- `flutter_local_notifications` - Notifications
- `hive` - Local storage

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Supabase project
- Google Maps API key (optional)
- Unsplash/Pexels API keys (optional)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-username/lifetimer.git
   cd lifetimer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your Supabase and API credentials
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Environment Variables
```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GOOGLE_MAPS_API_KEY=your_google_maps_key
UNSPLASH_API_KEY=your_unsplash_key
PEXELS_API_KEY=your_pexels_key
```

---

## 📱 Project Structure

```
lib/
├── main.dart                    # App entry point
├── bootstrap/                   # Initialization
├── core/                        # Cross-cutting concerns
│   ├── theme/
│   ├── routing/
│   ├── widgets/
│   ├── errors/
│   ├── utils/
│   └── services/
├── data/                        # Data layer
│   ├── models/
│   ├── repositories/
│   └── services/
└── features/                    # Feature modules
    ├── auth/
    ├── onboarding/
    ├── goals/
    ├── countdown/
    ├── social/
    ├── profile/
    ├── settings/
    ├── analytics/
    └── achievements/
```

---

## 🗄 Database Schema

### Core Tables
- `users` - User profiles and countdown data
- `goals` - Bucket list items with progress
- `goal_steps` - Granular milestones for goals
- `followers` - Social relationships
- `activities` - Timeline events for feeds
- `notifications` - Notification history
- `achievements` - User achievement tracking

### Security
- Row Level Security (RLS) enabled on all tables
- Users can only access their own data
- Public profiles expose only non-sensitive fields
- GDPR and CCPA compliant

---

## 🧪 Testing

### Test Coverage
- ✅ Unit tests for core utilities and models
- ✅ Widget tests for all screens and components
- ✅ Integration tests for end-to-end flows
- ✅ All tests passing

### Running Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

---

## 📊 Development Status

### Completed Phases
- ✅ **Phase 0**: Planning and foundations
- ✅ **Phase 1**: MVP core experience
- ✅ **Phase 2**: Social and motivation features
- ✅ **Phase 3**: Advanced experience features
- ✅ **Phase 4**: Polish and release preparation

### Current Status
- All core features implemented
- Comprehensive testing complete
- Documentation ready
- Beta testing phase starting
- App store submission preparation

---

## 📚 Documentation

### User Documentation
- [User Guide](lifetimer/USER_GUIDE.md) - Comprehensive user manual
- [FAQ](lifetimer/FAQ.md) - Frequently asked questions
- [Release Notes](lifetimer/RELEASE_NOTES.md) - v1.0.0 release information

### Developer Documentation
- [Developer Guide](lifetimer/DEVELOPER_GUIDE.md) - Setup and contribution guide
- [Security Audit Checklist](lifetimer/app_store_assets/security_audit_checklist.md)
- [Code Review Checklist](lifetimer/app_store_assets/code_review_checklist.md)

### Release Documentation
- [Beta Testing Plan](lifetimer/app_store_assets/beta_testing_plan.md)
- [Release Preparation Checklist](lifetimer/app_store_assets/release_preparation_checklist.md)
- [App Store Descriptions](lifetimer/app_store_assets/app_store_description.md)

---

## 🎯 App Store Information

### iOS App Store
- **Category**: Productivity
- **Age Rating**: 4+
- **Size**: ~50MB
- **Features**: In-app purchases, social features

### Google Play Store
- **Category**: Productivity
- **Content Rating**: Everyone
- **Size**: ~45MB
- **Features**: In-app purchases, social features

---

## 🤝 Contributing

We welcome contributions! Please see the [Developer Guide](lifetimer/DEVELOPER_GUIDE.md) for detailed guidelines.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🆘 Support

- **Email**: support@lifetimer.app
- **Twitter**: @LifeTimerApp
- **Discord**: https://discord.gg/lifetimer
- **Website**: https://lifetimer.app
- **Issues**: [GitHub Issues](https://github.com/your-username/lifetimer/issues)

---

## 🎉 Roadmap

### Version 1.1 (Post-Launch)
- [ ] Home screen widgets
- [ ] Custom countdown durations
- [ ] Advanced analytics
- [ ] More achievement types

### Version 1.2 (Future)
- [ ] Team challenges
- [ ] Goal templates
- [ ] Integration with calendar apps
- [ ] Apple Watch companion app

---

## 📈 Success Metrics

### Launch Targets
- **Week 1**: 1,000+ downloads, 4.5+ star rating, <1% crash rate
- **Month 1**: 5,000+ downloads, 4.5+ star rating, 40%+ Day 30 retention
- **Year 1**: 100,000+ downloads, 4.5+ star rating, 20%+ Day 90 retention

---

## 🏆 Project Statistics

- **Total Files**: 80+ Dart files
- **Lines of Code**: ~15,000+
- **Features**: 10+ feature modules
- **Screens**: 20+ screens
- **Test Coverage**: Comprehensive
- **Development Time**: 4 phases completed

---

**LifeTimer** - Make every day count. Start your 1356-day journey today!
