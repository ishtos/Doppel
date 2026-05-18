# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep FlutterLocalNotificationsPlugin for scheduled notifications
-keep class com.dexterous.** { *; }

# Google Fonts — OkHttp used internally
-dontwarn okhttp3.**
-dontwarn okio.**

# Prevent stripping of annotations used by Kotlin serialization
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses

# Kotlin coroutines
-dontwarn kotlinx.coroutines.**
