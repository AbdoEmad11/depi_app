# depi_App - Rick and Morty Character Explorer

A Flutter app for exploring Rick and Morty characters with authentication and smooth animations.

## 🚀 How to Run

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Setup Firebase**
   - Create Firebase project
   - Enable Email/Password authentication
   - Add `google-services.json` to `android/app/`

3. **Run the app**
   ```bash
   flutter run
   ```

##  State Management

**Flutter Bloc (Cubit)** is used for state management:

- **AuthCubit**: Handles user authentication (login/register/logout)
- **CharactersCubit**: Manages character data and API calls
- **States**: Loading, Success, Error states for each feature

## ✨ Animations

The app includes several smooth animations:

- **Screen Transitions**: Slide animations between login/register screens
- **Character Cards**: Staggered fade-in animations for character list
- **Hero Animations**: Smooth image transitions
- **Loading States**: Animated progress indicators
- **Form Elements**: Fade and slide animations on login/register screens