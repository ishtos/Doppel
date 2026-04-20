## Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

## Hive
-keep class * extends com.google.protobuf.GeneratedMessageLite { *; }

## http / OkHttp
-dontwarn okhttp3.**
-dontwarn okio.**

## just_audio (ExoPlayer) - FIXED: added for release build stability
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**

## record - FIXED: keep native recorder classes
-keep class com.llfbandit.record.** { *; }

## flutter_tts - FIXED: keep native TTS classes
-keep class com.tundralabs.** { *; }

## Keep annotations
-keepattributes *Annotation*

## Notification plugin
-keep class com.dexterous.** { *; }
