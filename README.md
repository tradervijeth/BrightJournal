# Bright Journal

An AI-powered personal journaling app built with SwiftUI and Apple Intelligence.

## Features

- **AI-Powered Text Reframing**: Uses Apple's Writing Tools to help reframe negative thoughts into positive, growth-oriented reflections
- **On-Device Mood Analysis**: Simple sentiment analysis that runs entirely on your device
- **Monthly AI Summaries**: Generate insights and themes from your entries using Apple Intelligence
- **Complete Privacy**: All processing happens on-device or through Apple's Private Cloud Compute
- **No Tracking**: Zero analytics, advertising, or user tracking

## Apple Intelligence Integration

This app leverages Apple Intelligence in the following ways:

1. **Writing Tools Integration**: 
   - Rewrite functionality for positive reframing
   - Summarization for monthly reports
   - Proofreading support in text editors

2. **On-Device Processing**:
   - Sentiment analysis using local keyword matching
   - Text processing without external API calls

3. **Private Cloud Compute (when needed)**:
   - Automatic fallback for complex AI tasks
   - Strong privacy guarantees maintained

## Requirements

- iOS 18.1+ 
- Apple Intelligence-capable device:
  - iPhone 15 Pro/Max or newer
  - iPad with A17 Pro/M1+ chip
  - Mac with M1+ chip

## Privacy & Compliance

- **Data Storage**: All entries stored locally using SwiftData
- **No External APIs**: No third-party AI services or analytics
- **App Store Compliant**: Follows all Apple guidelines for AI-powered apps
- **Age Rating**: 17+ (due to AI-generated content)
- **Medical Disclaimer**: Not intended as medical advice or therapy

## Architecture

- **SwiftUI + SwiftData**: Modern iOS development stack
- **MVVM Pattern**: Clean separation of concerns
- **Apple Intelligence APIs**: Official Apple AI integration
- **Local-First**: Everything works offline

## Development Setup

1. Open `BrightJournal.xcodeproj` in Xcode 15+
2. Select a simulator or device with Apple Intelligence support
3. Build and run (⌘+R)

## TODOs for Production

- [ ] Implement actual Writing Tools API integration
- [ ] Add App Intents for Shortcuts support
- [ ] Implement Image Playground for mood stickers
- [ ] Add iCloud sync configuration
- [ ] Complete App Store metadata and screenshots
- [ ] Finalize privacy manifest

## License

This project is provided as a development template. Modify as needed for your use case.