# --- Flutter Core ---
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# --- Firebase Core & Auth ---
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# --- Gemini AI (google_generative_ai) ---
# Prevent obfuscation of JSON models used by Gemini SDK
-keep class com.google.ai.client.generativeai.** { *; }

# --- Google Sign-In & Drive APIs ---
-keep class com.google.api.services.drive.** { *; }
-keep class com.google.api.client.** { *; }
-dontwarn com.google.api.client.**

# --- Drift (SQLite) ---
# Drift relies on reflection and specific class naming for DB generation
-keep class net.sqlcipher.** { *; }
-keep class org.sqlite.** { *; }

# --- Notification Service ---
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# --- General Reflection / JSON Serialization ---
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod

# --- Fix R8 Missing Class Errors (Play Core) ---
-dontwarn com.google.android.play.core.**
