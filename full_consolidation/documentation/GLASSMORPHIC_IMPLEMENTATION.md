# Iraq Compass - Glassmorphic Implementation Guide

## ✅ Phase 1: Design System - COMPLETE

### Color Palette Implemented
- **Primary**: `#6C2BD9` (Deep Cosmic Purple)
- **Secondary**: `#00D9FF` (Electric Cyan)  
- **Accent**: `#FF2E97` (Neon Pink)
- **Dark Background**: `#0A0E27`

### Tailwind Extensions Added
- Custom color scales (50-900 for each color)
- Glow shadows (`glow-primary`, `glow-secondary`, `glow-accent`)
- Glass shadows (`glass`, `glass-lg`)
- Custom animations (`float`, `glow`, `pulse-slow`)

### Background Gradient
Body now has fixed radial gradients for ambient glow effect.

---

## 📋 Next Steps - Component Implementation

### Priority Order:
1. ✅ Design System Setup
2. 🔄 Hero Section with AI Search Portal
3. ⏳ Stories Ring Component
4. ⏳ Category Grid (9-grid)
5. ⏳ Featured Businesses
6. ⏳ AI-Curated Events
7. ⏳ Deals Marketplace
8. ⏳ Community Stories Viewer
9. ⏳ City Navigator (Leaflet)
10. ⏳ Business Directory
11. ⏳ Inclusive Features Hub

---

## 🎨 Glassmorphism Utility Classes

### Already Available in index.css:
```css
.glass-card - Basic frosted glass card
.glass-card-hover - Glass card with hover effects
.glass-button - Frosted glass button
.glass-input - Glass input field
.glass-modal - Glass modal overlay
.glass-chip - Small glass chip/tag
```

### Tailwind Classes to Use:
```jsx
// Standard Glass Surface
className="backdrop-blur-xl bg-white/5 border border-white/10 rounded-2xl"

// Hover Glow Effect
className="hover:shadow-glow-primary transition-all duration-300"

// Gradient Buttons
className="bg-gradient-to-r from-primary to-secondary"

// Accent Gradient
className="bg-gradient-to-br from-accent to-primary"
```

---

## 🔧 Technical Stack

### Maps
- **Leaflet** (free, no API key)
- Install: `npm install leaflet react-leaflet`

### Images
- **Unsplash Source API** (free, no key)
- Format: `https://source.unsplash.com/800x600/?{keyword}`

### Icons
- Using existing icon components from `src/components/icons.tsx`
- Can add Lucide React if needed: `npm install lucide-react`

### Backend Integration
- Connect to existing services in `src/services/`:
  - `geminiService.ts` - AI event generation
  - `recommendationEngine.ts` - Smart recommendations
  - `searchService.ts` - Intelligent search
  - `api.ts` - API calls

---

## 📱 Responsive Breakpoints

```jsx
sm: 640px   // Mobile landscape
md: 768px   // Tablet
lg: 1024px  // Desktop
xl: 1280px  // Large desktop
2xl: 1536px // Extra large
```

### Mobile-First Approach
```jsx
// Default: Mobile
className="grid-cols-1"

// Tablet and up
className="md:grid-cols-2"

// Desktop and up
className="lg:grid-cols-3"
```

---

## 🌍 Multi-Language Support

### Language Codes
- `en` - English
- `ar` - Iraqi Arabic (RTL)
- `ku` - Kurdish Sorani (RTL)

### RTL Handling
```jsx
// Conditional classes based on language
className={`${lang === 'ar' || lang === 'ku' ? 'rtl' : 'ltr'}`}

// Or use Tailwind RTL variants
className="ltr:ml-4 rtl:mr-4"
```

---

## 🎯 Component File Structure

```
src/
├── components/
│   ├── home/
│   │   ├── HeroSection.tsx
│   │   ├── SearchPortal.tsx
│   │   ├── StoriesRing.tsx
│   │   ├── CategoryGrid.tsx
│   │   ├── FeaturedBusinesses.tsx
│   │   ├── PersonalizedEvents.tsx
│   │   ├── DealsMarketplace.tsx
│   │   ├── CommunityStories.tsx
│   │   ├── CityNavigator.tsx
│   │   ├── BusinessDirectory.tsx
│   │   └── InclusiveFeatures.tsx
│   ├── shared/
│   │   ├── GlassCard.tsx
│   │   ├── GlassButton.tsx
│   │   ├── GlassInput.tsx
│   │   └── VoiceSearchButton.tsx
│   └── modals/
│       ├── SubcategoryModal.tsx
│       ├── StoryViewer.tsx
│       └── BusinessDetailModal.tsx
├── hooks/
│   ├── useVoiceSearch.ts
│   └── useLanguage.ts
└── utils/
    ├── nlpProcessor.ts
    └── contentModeration.ts
```

---

## 🚀 Implementation Checklist

### Phase 2: Core Components
- [ ] Create `src/components/home/` directory
- [ ] Build HeroSection with animated background
- [ ] Implement SearchPortal with voice search UI
- [ ] Create StoriesRing component
- [ ] Build CategoryGrid with 9-grid layout
- [ ] Implement SubcategoryModal

### Phase 3: Feature Slides
- [ ] FeaturedBusinesses horizontal scroll
- [ ] PersonalizedEvents with AI tabs
- [ ] DealsMarketplace with countdown timers
- [ ] CommunityStories grid + viewer
- [ ] CityNavigator with Leaflet map
- [ ] BusinessDirectory with filters
- [ ] InclusiveFeatures hub

### Phase 4: AI Integration
- [ ] Voice search hook
- [ ] NLP query processing
- [ ] Connect to geminiService
- [ ] Connect to recommendationEngine
- [ ] Content moderation for stories

### Phase 5: Polish
- [ ] Mobile responsive testing
- [ ] RTL support testing
- [ ] Accessibility audit
- [ ] Performance optimization
- [ ] Loading states
- [ ] Error boundaries

---

## 💡 Key Design Principles

1. **Glass First**: Every card/surface uses glassmorphism
2. **Glow on Hover**: Interactive elements glow on hover
3. **Smooth Transitions**: All state changes animated (300ms)
4. **Mobile Touch**: 44px minimum touch targets
5. **RTL Ready**: All layouts work in Arabic/Kurdish
6. **AI Visible**: Show AI features with sparkle icons
7. **Accessibility**: WCAG AA contrast, keyboard navigation

---

## 🎨 Example Component Pattern

```tsx
// Standard glassmorphic component
const ExampleCard = () => {
  return (
    <div className="
      backdrop-blur-xl bg-white/5
      border border-white/10
      rounded-2xl p-6
      hover:bg-white/10
      hover:border-primary/50
      hover:shadow-glow-primary
      transition-all duration-300
      group
    ">
      <h3 className="text-white font-semibold mb-2">
        Title
      </h3>
      <p className="text-white/70 text-sm">
        Description
      </p>
      <button className="
        mt-4 w-full py-3 rounded-xl
        bg-gradient-to-r from-primary to-secondary
        text-white font-semibold
        hover:shadow-glow-primary-lg
        transition-all duration-200
      ">
        Action
      </button>
    </div>
  );
};
```

---

## 📦 Dependencies to Install

```bash
# Maps
npm install leaflet react-leaflet
npm install -D @types/leaflet

# Icons (if needed beyond existing)
npm install lucide-react

# Animations (optional)
npm install framer-motion

# Date formatting
npm install date-fns
```

---

## 🔗 Backend Service Integration Example

```tsx
import { geminiService } from '@/services/geminiService';
import { recommendationEngine } from '@/services/recommendationEngine';

// In component
const handleAISearch = async (query: string) => {
  const suggestions = await geminiService.getAISuggestions(
    query,
    cities,
    categories
  );
  
  const recommendations = await recommendationEngine.getRecommendations({
    userId: currentUser?.id,
    userPreferences: userPreferences,
    limit: 10
  });
  
  // Display results
};
```

---

## ✅ Status: Ready for Component Development

All design tokens, utilities, and configurations are in place.
Next: Build Hero Section and Search Portal.
