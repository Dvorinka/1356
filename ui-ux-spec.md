# LifeTimer  UI and UX Specification

This document translates the visual inspiration screenshots into a concrete style for LifeTimer.

## 1. Design principles

- Calm and motivational, not alarming.
- Focus on remaining time and meaningful goals.
- Simple flows that are friendly for non technical users.

## 2. Visual style

Inspiration

- Travel app mockups, card based layout with large imagery and rounded corners for each trip or tour.
- Mood tracking mockups, playful colors, rounded shapes, friendly typography and clear emphasis on current emotional state.
- World time mockups, very large digits and clean layouts that highlight time and locations.

Application to LifeTimer

- Home countdown uses a large typographic layout similar to the world time example, centered on the screen with remaining days as the main focus.
- Bucket list and goals use cards with images similar to the travel example. Each card shows goal title, progress, and remaining time.
- Emotional tone uses gentle pastel colors inspired by the mood app, with clear contrast in dark mode.

## 3. Color and themes

- Primary palette, soft blues and greens for calm, accented with a highlight color for positive actions.
- Light theme, light background with strong contrast for text, subtle shadows for cards.
- Dark theme, very dark background, desaturated colors, neon like highlight accents for countdown and important actions.
- Separate color tokens for success, warning, and neutral informational states.

## 4. Typography

- Use one clean sans serif font family for consistency.
- Large numeric style for the countdown, using extra bold weight.
- Titles and section headers use medium or semibold weight.
- Body text remains highly readable at standard platform sizes with support for dynamic type.

## 5. Layout and components

- Global bottom navigation with four or five destinations
  - Home
  - Goals
  - Social
  - Profile
  - Optional, Insights
- Reusable components
  - Goal card with image, title, location, progress bar, and call to action.
  - Progress summary card with small chart and key metrics.
  - Primary button with pill shape, full width on narrow screens.
  - Chip components for filters such as time range, goal categories, or mood tags.
- Consistent safe area and spacing across all screens.

## 6. Feedback and states

- Loading, skeleton placeholders for cards and lists, not blank screens.
- Empty states, friendly illustration and one clear action, for example Add your first goal.
- Error states, concise error message, optional retry button, and no technical jargon.
- Success, subtle confetti, glow, or color shift when a goal is completed or a big milestone is reached.

## 7. Motion

- Light micro interactions for taps, card selection, and tab transitions.
- Simple transitions between screens, preferably default Flutter transitions with small custom tweaks.
- Avoid heavy or distracting animations on the countdown screen.

## 8. Accessibility

- Minimum contrast ratio respected for text and essential icons.
- Avoid relying only on color for progress; include labels and percentage values.
- Support system text scaling; layouts must not break at larger text sizes.
