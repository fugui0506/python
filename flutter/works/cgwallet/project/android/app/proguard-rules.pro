-keep class com.netease.nis.alivedetected.entity.*{*;}
-keep class com.netease.nis.alivedetected.AliveDetector  {
    public <methods>;
    public <fields>;
}
-keep class com.netease.nis.alivedetected.DetectedEngine{
    native <methods>;
}
-keep class com.netease.nis.alivedetected.NISCameraPreview  {
    public <methods>;
}

-keep class org.slf4j.** { *; }
-dontwarn org.slf4j.**

-keep class com.netease.nis.alivedetected.DetectedListener{*;}
-keep class com.netease.nis.alivedetected.ActionType{ *;}

-dontwarn org.bouncycastle.jsse.BCSSLParameters
-dontwarn org.bouncycastle.jsse.BCSSLSocket
-dontwarn org.bouncycastle.jsse.provider.BouncyCastleJsseProvider
-dontwarn org.conscrypt.Conscrypt$Version
-dontwarn org.conscrypt.Conscrypt
-dontwarn org.conscrypt.ConscryptHostnameVerifier
-dontwarn org.openjsse.javax.net.ssl.SSLParameters
-dontwarn org.openjsse.javax.net.ssl.SSLSocket
-dontwarn org.openjsse.net.ssl.OpenJSSE

# 起聊 SDK 保留
-keep class com.teneasy.** { *; }
-keep class com.teneasyChat.** { *; }
-keep class com.google.protobuf.** { *; }