# ML Kit text recognition — R8 strips these because TextRecognizer.initialize()
# references them by name but they are not declared as dependencies.
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }
-keep class com.google.mlkit.vision.text.latin.** { *; }

# Google Play Services (Ads, Billing) — shrinker commonly flags these
-dontwarn com.google.android.gms.**
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.android.gms.internal.ads.** { *; }

# Flutter / plugin channel code
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# in_app_purchase
-keep class com.android.billingclient.** { *; }
-dontwarn com.android.billingclient.**

# flutter_doc_scanner (if it bundles native scanning via reflection)
-dontwarn com.google.android.gms.internal.vision.**

# Keep annotations and native methods
-keepattributes *Annotation*
-keepclasseswithmembernames class * {
    native <methods>;
}
