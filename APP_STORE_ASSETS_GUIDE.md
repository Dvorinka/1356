# App Store Submission Assets Guide

**Project:** LifeTimer  
**Version:** 1.0.0  
**Date:** 2026-01-03

## App Icons

### iOS App Icon Requirements

**Required Sizes:**
- 1024x1024px (App Store submission)
- 180x180px (iPhone App @3x)
- 167x167px (iPad Pro @2x)
- 152x152px (iPad @2x)
- 120x120px (iPhone @2x)
- 87x87px (iPhone @3x Notification)
- 80x80px (iPad @2x Spotlight)
- 76x76px (iPad @1x)
- 60x60px (iPhone @2x Notification)
- 58x58px (iPhone @2x Settings)
- 40x40px (iPhone @2x Spotlight)
- 29x29px (iPhone @2x Settings)

**Design Guidelines:**
- Use the primary brand color (#6366F1)
- Incorporate a countdown or hourglass visual element
- Clean, minimal design
- No text or words on the icon
- Rounded corners (iOS will apply automatically)
- High contrast for accessibility

**Recommended Icon Concept:**
- A stylized hourglass with sand flowing
- Or a circular progress ring with "1356" text
- Gradient from primary (#6366F1) to secondary (#8B5CF6)

### Android App Icon Requirements

**Required Sizes:**
- 512x512px (Google Play Store)
- 192x192px (Adaptive Icon)
- 144x144px (Master Icon)
- 96x96px (Master Icon)
- 72x72px (Master Icon)
- 48x48px (Master Icon)

**Design Guidelines:**
- Use adaptive icon format for Android 8.0+
- Safe zone: 66% of the icon (center 2/3)
- Background layer: Full 192x192px
- Foreground layer: 108x108px centered
- No transparency in background layer

## App Store Screenshots

### iOS Screenshots

**Required Sizes:**
- 6.7" Display: 1290x2796px (iPhone 14 Pro Max)
- 6.5" Display: 1242x2688px (iPhone XS Max)
- 5.5" Display: 1242x2208px (iPhone 8 Plus)

**Minimum:** 3 screenshots  
**Recommended:** 5-6 screenshots

**Screenshot Order & Content:**

1. **Home Countdown Screen**
   - Large countdown timer display
   - Progress ring showing time elapsed
   - Clean, inspiring design
   - Caption: "Track Your 1356-Day Journey"

2. **Goals List Screen**
   - List of bucket list items
   - Progress indicators
   - Add goal button
   - Caption: "Create Your Bucket List"

3. **Goal Detail Screen**
   - Goal with progress slider
   - Milestones/steps
   - Location and image
   - Caption: "Track Your Progress"

4. **Profile Screen**
   - User avatar and stats
   - Countdown summary
   - Achievements
   - Caption: "Your Personal Dashboard"

5. **Social Feed Screen**
   - Activity feed
   - Leaderboards
   - Community achievements
   - Caption: "Join the Community"

6. **Settings Screen**
   - Theme options
   - Notification settings
   - Privacy controls
   - Caption: "Customize Your Experience"

**Design Guidelines:**
- Use actual app screenshots (no mockups)
- Show full screen content
- Include status bar with time
- No device frames
- Consistent lighting and colors
- English text only

### Android Screenshots

**Required Sizes:**
- Phone: 1080x1920px (minimum)
- Tablet: 1200x1920px (optional)
- 7-inch Tablet: 1264x1264px (optional)

**Minimum:** 2 screenshots  
**Recommended:** 8 screenshots

**Screenshot Content:** Same as iOS but optimized for Android UI

## App Store Preview Videos (Optional)

### iOS App Preview

**Requirements:**
- 15-30 seconds
- 1920x1080px (16:9 aspect ratio)
- MP4 or MOV format
- Under 500MB

**Content Suggestion:**
- 0-3s: App splash screen
- 3-8s: Creating bucket list
- 8-13s: Starting countdown
- 13-18s: Tracking progress
- 18-23s: Viewing achievements
- 23-30s: App logo with tagline

### Android Promo Video

**Requirements:**
- 30 seconds - 2 minutes
- 1920x1080px (16:9 aspect ratio)
- YouTube link

## Feature Graphic (Android)

**Requirements:**
- 1024x500px
- JPG or 24-bit PNG (no alpha)
- No transparency

**Design:**
- App logo on left
- Tagline: "Your 1356-Day Life Challenge"
- Gradient background matching app theme
- Clean, modern design

## Promotional Text

### iOS Promotional Text (170 characters max)
```
Transform your life with a 1356-day countdown. Create your bucket list, track progress, and achieve your dreams.
```

### iOS Description (4000 characters max)
See `APP_STORE_DESCRIPTIONS.md`

### Android Short Description (80 characters max)
```
1356-day life countdown with bucket list tracking
```

### Android Full Description (4000 characters max)
See `APP_STORE_DESCRIPTIONS.md`

## Store Listing Assets

### Privacy Policy URL
- Required for both stores
- Create at: `https://lifetimer.app/privacy`

### Support URL
- Required for both stores
- Create at: `https://lifetimer.app/support`

### Marketing URL
- Optional
- Create at: `https://lifetimer.app`

## Asset Creation Checklist

### Icons
- [ ] Design app icon concept
- [ ] Create iOS icon set (all sizes)
- [ ] Create Android adaptive icon
- [ ] Create Android legacy icon
- [ ] Test icons on actual devices
- [ ] Verify contrast and readability

### Screenshots
- [ ] Set up test data in app
- [ ] Capture iOS screenshots (6.7" display)
- [ ] Capture Android screenshots (1080x1920)
- [ ] Review and edit for consistency
- [ ] Verify all text is readable
- [ ] Ensure no personal data visible

### Videos (Optional)
- [ ] Script storyboard
- [ ] Record screen footage
- [ ] Add transitions and effects
- [ ] Add background music (optional)
- [ ] Export in required format
- [ ] Test on target devices

### Graphics
- [ ] Design Android feature graphic
- [ ] Create promotional banner
- [ ] Design social media assets

## Tools for Asset Creation

### Icons
- **Figma** - Design and export icons
- **Sketch** - Design tool (macOS)
- **AppIconGenerator** - Generate all sizes
- **MakeAppIcon** - Online icon generator

### Screenshots
- **Fastlane Snapshot** - Automated screenshots
- **Simulator** - iOS screenshots
- **Android Emulator** - Android screenshots
- **CleanShot X** - Screenshot tool (macOS)

### Videos
- **QuickTime** - Screen recording (macOS)
- **OBS Studio** - Screen recording (cross-platform)
- **iMovie** - Video editing (macOS)
- **DaVinci Resolve** - Professional video editing

### Graphics
- **Canva** - Online design tool
- **Adobe Photoshop** - Professional design
- **Figma** - Design and prototyping

## Asset Storage

### Local Storage Structure
```
lifetimer/
├── assets/
│   ├── icons/
│   │   ├── ios/
│   │   │   ├── 1024x1024.png
│   │   │   ├── 180x180.png
│   │   │   └── ...
│   │   └── android/
│   │       ├── adaptive_foreground.png
│   │       ├── adaptive_background.png
│   │       └── ...
│   ├── screenshots/
│   │   ├── ios/
│   │   │   ├── 1_home_countdown.png
│   │   │   ├── 2_goals_list.png
│   │   │   └── ...
│   │   └── android/
│   │       ├── phone_1_home_countdown.png
│   │       ├── phone_2_goals_list.png
│   │       └── ...
│   └── graphics/
│       ├── feature_graphic.png
│       └── promo_banner.png
```

## Submission Checklist

### iOS App Store
- [ ] App icon (1024x1024px)
- [ ] Screenshots (minimum 3, all required sizes)
- [ ] App preview video (optional)
- [ ] Promotional text
- [ ] Description
- [ ] Keywords (100 characters)
- [ ] Support URL
- [ ] Marketing URL (optional)
- [ ] Privacy policy URL
- [ ] App category: "Lifestyle" or "Productivity"
- [ ] Age rating: Calculate with rating tool
- [ ] Export compliance information
- [ ] Content rights

### Google Play Store
- [ ] High-res icon (512x512px)
- [ ] Feature graphic (1024x500px)
- [ ] Screenshots (minimum 2)
- [ ] Short description (80 chars)
- [ ] Full description (4000 chars)
- [ ] Promo video (optional)
- [ ] Application type: "Application"
- [ ] Category: "Lifestyle"
- [ ] Content rating questionnaire
- [ ] Privacy policy URL
- [ ] Website URL
- [ ] Email address for support
- [ ] Store listing experiments (optional)

## Notes

- All assets should be in English for initial launch
- Consider localized assets for future markets
- Test all assets on actual devices before submission
- Keep original design files for future updates
- Follow each store's design guidelines precisely
- Assets may be rejected if they don't meet specifications

---

**Next Steps:**
1. Design app icon concept
2. Create all required icon sizes
3. Set up test data in app
4. Capture screenshots for both platforms
5. Create promotional graphics
6. Prepare store listings
7. Submit to both app stores
