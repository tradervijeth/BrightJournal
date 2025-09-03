# App Review Note: Bright Journal

## App Overview

Bright Journal is a personal journaling app that uses Apple Intelligence to help users reframe negative thoughts into positive reflections and generate monthly summaries of their emotional journey.

## Apple Intelligence Features Used

### 1. Writing Tools Integration
- **Feature**: Text rewriting and summarization in standard TextEditor components
- **Implementation**: Uses Apple's Writing Tools API for positive reframing
- **Privacy**: All processing handled by Apple Intelligence (on-device or Private Cloud Compute)
- **User Control**: Users initiate rewriting manually; original text always preserved

### 2. On-Device Sentiment Analysis
- **Feature**: Simple mood tagging based on keyword matching
- **Implementation**: Local algorithm, no external API calls
- **Privacy**: Completely on-device processing
- **Accuracy**: Basic sentiment detection for personal insight only

### 3. Monthly Summary Generation (Planned)
- **Feature**: AI-generated insights from journal entries
- **Implementation**: Will use Writing Tools summarization API
- **Privacy**: User's own content processed by Apple Intelligence
- **Control**: User-initiated, can be deleted anytime

## Privacy & Data Handling

- **Local Storage**: All journal entries stored using SwiftData on device
- **No External Servers**: Zero third-party API calls or data transmission
- **iCloud Sync**: Optional, handled by iOS system (user controls in Settings)
- **No Tracking**: No analytics, advertising, or user behavior monitoring
- **Apple Intelligence**: Processing via official Apple APIs only

## Device & OS Requirements

- **Minimum iOS**: 18.1 (for Apple Intelligence features)
- **Compatible Devices**: 
  - iPhone 15 Pro/Max or newer
  - iPad with A17 Pro or M1+ chip
  - Mac with M1+ chip or newer
- **Fallback**: App provides basic journaling on non-AI devices

## Content & Safety

- **Age Rating**: 17+ (AI-generated content may vary)
- **Medical Disclaimer**: Prominent notice that app is not medical advice
- **Content Policy**: Terms prohibit abusive or harmful content
- **User Generated**: All AI prompts come from user's own journal entries

## Compliance Notes

- **Privacy Manifest**: Declares no data collection
- **App Privacy Labels**: "No data collected" across all categories
- **Terms of Service**: Includes acceptable use and medical disclaimers
- **Private Cloud Compute**: Automatic privacy protection for complex AI requests

## Testing Instructions

1. **Basic Functionality**: Create journal entries, edit, delete
2. **AI Reframing**: Test "Reframe with Positivity" button (requires Apple Intelligence)
3. **Monthly Summary**: Generate summary from multiple entries
4. **Settings**: Review privacy policy and terms
5. **Offline Mode**: Verify app works without internet (except PCC when needed)

## Technical Implementation

- **Framework**: SwiftUI + SwiftData for modern iOS development
- **Architecture**: MVVM pattern with proper separation of concerns
- **Error Handling**: Graceful fallback when AI features unavailable
- **Performance**: Optimized for on-device processing

## Future Updates

- App Intents for Shortcuts integration
- Image Playground for mood stickers
- Enhanced Writing Tools integration
- Improved accessibility features

---

**Contact**: [Your developer contact information]
**App Store Connect ID**: [When available]
**Bundle ID**: com.yourcompany.brightjournal