# Translation Guide for Resonate

Thank you for your interest in helping translate Resonate! This guide will walk you through the process of adding translations to make the app accessible to users worldwide.

## Overview

Resonate uses Flutter's internationalization (i18n) framework with ARB (Application Resource Bundle) files to manage translations. Currently, the app supports:

- **English (en)** - Primary language (template)
- **Hindi (hi)** - Secondary language

## Getting Started

### Prerequisites

Before you begin translating, make sure you have:

1. **Flutter SDK** installed on your system
2. **Git** for version control
3. **Basic understanding** of JSON syntax
4. **Familiarity** with the target language and its cultural context

### Repository Setup

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Resonate.git
   cd Resonate
   ```
3. **Create a new branch** for your translation work:
   ```bash
   git checkout -b translation-YOUR_LANGUAGE_CODE
   ```

## Translation Files Structure

Translation files are located in the `lib/l10n/` directory:

```
lib/l10n/
├── app_en.arb    # English (template file)
├── app_hi.arb    # Hindi
└── app_YOUR_LANGUAGE_CODE.arb  # Your new translation
```

### Configuration Files

- **`l10n.yaml`** - Configuration file for Flutter's localization system
- **`untranslated.txt`** - Lists untranslated messages (auto-generated)

## Adding a New Language

### Step 1: Create Your ARB File

1. **Copy the template file:**
   ```bash
   cp lib/l10n/app_en.arb lib/l10n/app_YOUR_LANGUAGE_CODE.arb
   ```

2. **Add the locale identifier** at the beginning of your new file:
   ```json
   {
       "@@locale": "YOUR_LANGUAGE_CODE",
       "title": "Resonate",
       ...
   }
   ```

### Step 2: Register Your Language in App Configuration

Before translating, you need to register your new language in the app's configuration files:

#### Update main.dart

Add your language code to the `supportedLocales` list in `lib/main.dart`:

```dart
supportedLocales: [
  Locale('en'),
  Locale('hi'),
  Locale('YOUR_LANGUAGE_CODE'),  // Add your language here
],
```

#### Update iOS Configuration (iOS only)

Add your language code to the `CFBundleLocalizations` array in `ios/Runner/Info.plist`:

```xml
<key>CFBundleLocalizations</key>
<array>
    <string>hi</string>
    <string>en</string>
    <string>YOUR_LANGUAGE_CODE</string>  <!-- Add your language here -->
</array>
```

**Note:** 
- The order in both files doesn't matter, but it's recommended to maintain alphabetical order for consistency.
- For Android, no additional configuration is needed as Flutter automatically detects supported locales from the ARB files.

### Step 3: Translate the Content

Open your new ARB file and translate each string value while keeping the keys unchanged.

#### Example Translation Structure:
```json
{
    "@@locale": "es",
    "title": "Resonate",
    "roomDescription": "Sé educado y respeta la opinión de la otra persona. Evita comentarios groseros.",
    "hidePassword": "Ocultar Contraseña",
    "showPassword": "Mostrar Contraseña",
    "passwordEmpty": "La contraseña no puede estar vacía",
    "password": "Contraseña"
}
```

#### Important Guidelines:

- **Keep JSON keys unchanged** - Only translate the values
- **Preserve placeholders** - Text like `{username}` should remain unchanged
- **Maintain formatting** - Preserve line breaks (`\n`) and special characters
- **Handle metadata** - Don't translate `@` prefixed keys, but do translate description values

#### Example with Placeholders:
```json
{
    "welcomeMessage": "Welcome, {username}!",
    "@welcomeMessage": {
        "description": "Message shown to welcome the user",
        "placeholders": {
            "username": {
                "type": "String",
                "example": "John"
            }
        }
    }
}
```

### Step 4: Handle Complex Translations

#### Plural Forms and Select Cases

Some strings use ICU message format for pluralization or selection:

```json
{
    "noAvailableRoom": "{isRoom, select, true{No Room Available} false{No Upcoming Room Available} other{No Room Information Available}}\nGet Started By Adding One Below!"
}
```

Translate each option while maintaining the structure:

```json
{
    "noAvailableRoom": "{isRoom, select, true{Keine Räume verfügbar} false{Keine bevorstehenden Räume verfügbar} other{Keine Rauminformationen verfügbar}}\nBeginnen Sie, indem Sie unten einen hinzufügen!"
}
```

### Step 5: Test Your Translations

1. **Run the app** with your translations:
   ```bash
   flutter run
   ```

2. **Generate localization files:**
   ```bash
   flutter gen-l10n
   ```

3. **Check for untranslated strings:**
   - Review the generated `untranslated.txt` file
   - Ensure all required strings are translated

### Step 6: Quality Assurance

Before submitting your translation:

#### Language Quality
- [ ] **Accuracy** - Translations convey the correct meaning
- [ ] **Cultural appropriateness** - Consider local customs and context
- [ ] **Consistency** - Use consistent terminology throughout
- [ ] **Grammar and spelling** - Check for linguistic errors

#### Technical Quality
- [ ] **JSON syntax** - Validate your ARB file is valid JSON
- [ ] **Placeholders preserved** - All `{variable}` placeholders intact
- [ ] **Metadata intact** - All `@` prefixed keys and structure preserved
- [ ] **App testing** - Test the app with your language

#### Validation Tools
```bash
# Validate JSON syntax
flutter pub get
flutter gen-l10n

# Check for missing translations
cat untranslated.txt
```

## Submitting Your Translation

### Step 1: Commit Your Changes

```bash
git add lib/l10n/app_YOUR_LANGUAGE_CODE.arb lib/main.dart ios/Runner/Info.plist
git commit -m "feat: add YOUR_LANGUAGE translation support

- Added complete translation for YOUR_LANGUAGE (YOUR_LANGUAGE_CODE)
- Translated all UI strings and messages
- Maintained placeholder and metadata structure
- Updated supportedLocales in main.dart
- Added language to iOS CFBundleLocalizations"
```

### Step 2: Create a Pull Request

1. **Push your branch:**
   ```bash
   git push origin translation-YOUR_LANGUAGE_CODE
   ```

2. **Create a Pull Request** to the `dev` branch with:
   - **Clear title:** `Add YOUR_LANGUAGE translation support`
   - **Description** including:
     - Language name and code
     - Translation completion status
     - Any cultural considerations or notes
     - Screenshots if possible

### Step 3: Review Process

Your pull request will be reviewed for:
- Translation quality and accuracy
- Technical correctness
- Consistency with existing translations
- App functionality with the new language

## Updating Existing Translations

To update an existing translation:

1. **Identify outdated strings** in `untranslated.txt`
2. **Compare with template** `app_en.arb` for new or changed strings
3. **Update your language file** with new translations
4. **Test thoroughly** before submitting

## Language Codes Reference

Use standard language codes (ISO 639-1) for your translations:

| Language             | Code | Example File |
| -------------------- | ---- | ------------ |
| Arabic               | ar   | app_ar.arb   |
| Chinese (Simplified) | zh   | app_zh.arb   |
| French               | fr   | app_fr.arb   |
| German               | de   | app_de.arb   |
| Japanese             | ja   | app_ja.arb   |
| Portuguese           | pt   | app_pt.arb   |
| Russian              | ru   | app_ru.arb   |
| Spanish              | es   | app_es.arb   |

## Resources and Tools

### Helpful Tools
- **JSON validators** - [jsonlint.com](https://jsonlint.com/)
- **ICU Message Format** - [Format.js](https://formatjs.io/docs/core-concepts/icu-syntax/)
- **Translation memory tools** - CAT tools for consistency

### Flutter Documentation
- [Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)
- [ARB File Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)

## Need Help?

If you encounter any issues or have questions:

1. **Check existing issues** on GitHub for similar problems
2. **Create a new issue** with the `translation` label
3. **Join our community** discussions for translation-related questions
4. **Contact maintainers** for complex translation decisions

## Recognition

All translators will be:
- **Credited** in the app's about section
- **Mentioned** in release notes
- **Added** to the contributors list

Thank you for helping make Resonate accessible to users around the world! 🌍
