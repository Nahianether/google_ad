package com.example.google_ad

import android.content.Context
import android.view.LayoutInflater
import android.widget.TextView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class ListTileNativeAdFactory(private val context: Context) : NativeAdFactory {
    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?
    ): NativeAdView {
        val nativeAdView = LayoutInflater.from(context)
            .inflate(R.layout.list_tile_native_ad, null) as NativeAdView

        val headlineView = nativeAdView.findViewById<TextView>(R.id.ad_headline)
        val bodyView = nativeAdView.findViewById<TextView>(R.id.ad_body)

        headlineView.text = nativeAd.headline
        nativeAdView.headlineView = headlineView

        if (nativeAd.body == null) {
            bodyView.visibility = android.view.View.INVISIBLE
        } else {
            bodyView.visibility = android.view.View.VISIBLE
            bodyView.text = nativeAd.body
            nativeAdView.bodyView = bodyView
        }

        nativeAdView.setNativeAd(nativeAd)

        return nativeAdView
    }
}