//
//  SwiftUIView.swift
//  KubSTU-iOS
//
//  Created by Руслан Соловьев on 08.10.2022.
//

import SwiftUI
import UIKit
import YandexMobileAds


struct BannerView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> BannerViewController {
        return BannerViewController()
    }
    
    func updateUIViewController(_ banner: BannerViewController, context: Context) {
        banner.loadAd()
    }
}

class BannerViewController: UIViewController {
    var adView: YMAAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Replace demo R-M-DEMO-320x50 with actual Ad Unit ID
        let adSize = YMAAdSize.flexibleSize(with: .init(width: UIScreen.main.bounds.width, height: 50))
        self.adView = YMAAdView(adUnitID: "R-M-DEMO-320x50", adSize: adSize)
        self.adView.delegate = self
    }
    
    @IBAction func loadAd() {
        self.adView.removeFromSuperview()
        self.adView.loadAd()
    }
}

extension BannerViewController: YMAAdViewDelegate {
    // Uncomment to open web links in in-app browser
//    func viewControllerForPresentingModalView() -> UIViewController? {
//        return self
//    }
    
    func adViewDidLoad(_ adView: YMAAdView) {
        self.adView.displayAtBottom(in: self.view)
        print("Ad loaded")
    }

    func adViewDidClick(_ adView: YMAAdView) {
        print("Ad clicked")
    }

    func adView(_ adView: YMAAdView, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("Impression tracked")
    }
    
    func adViewDidFailLoading(_ adView: YMAAdView, error: Error) {
        print("Ad failed loading. Error: \(error)")
    }
    
    func adViewWillLeaveApplication(_ adView: YMAAdView) {
        print("Ad will leave application")
    }
    
    func adView(_ adView: YMAAdView, willPresentScreen viewController: UIViewController?) {
        self.adView.loadAd()
    }

    func adView(_ adView: YMAAdView, didDismissScreen viewController: UIViewController?) {
        print("Ad did dismiss screen")
    }
    
}

