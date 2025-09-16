import GoogleMobileAds
import Foundation
import UIKit

class ListTileNativeAdFactory: FLTNativeAdFactory {

    func createNativeAd(_ nativeAd: GADNativeAd,
                       customOptions: [AnyHashable : Any]? = nil) -> GADNativeAdView? {
        let nibView = Bundle.main.loadNibNamed("ListTileNativeAdView", owner: nil, options: nil)?.first
        let nativeAdView = nibView as! GADNativeAdView

        (nativeAdView.headlineView as! UILabel).text = nativeAd.headline
        nativeAdView.headlineView!.isHidden = nativeAd.headline == nil

        (nativeAdView.bodyView as! UILabel).text = nativeAd.body
        nativeAdView.bodyView!.isHidden = nativeAd.body == nil

        nativeAdView.nativeAd = nativeAd

        return nativeAdView
    }
}