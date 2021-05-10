//
//  DetailViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import UIKit
import FLAnimatedImage
import Nuke
import NotificationBannerSwift

class DetailViewController: UIViewController {

    // MARK: - Properties
    var gif: Gif?
    var banner: NotificationBanner?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trendingLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let gif = self.gif else { return }
        Nuke.loadImage(with: gif.originalURL, options: nukeOptions, into: self.gifImageView)
        self.titleLabel.text = gif.title
        self.trendingLabel.text = gif.trendingDate
        self.sourceLabel.text = gif.source
    }
    
    func showBanner(success: Bool) {
        let title = success ? "복사완료!" : "복사실패"
        let subtitle = success ? gif!.title : "Clipboard 복사에 실패하였습니다."
        self.banner?.dismiss()
        self.banner = NotificationBanner(title: title, subtitle: subtitle, style: .success)
        self.banner?.haptic = .heavy
        self.banner?.duration = TimeInterval(1.5)
        self.banner?.bannerHeight = 100
        self.banner?.show()
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCopyButton(_ sender: Any) {
        DispatchQueue.global().async {
            guard let gif = self.gif else {
                DispatchQueue.main.sync {
                    self.showBanner(success: false)
                }
                return
            }
            
            guard let data = NSData(contentsOf: gif.originalURL) else {
                DispatchQueue.main.sync {
                    self.showBanner(success: false)
                }
                return
            }
            
            UIPasteboard.general.setData(data as Data, forPasteboardType: "com.compuserve.gif")
            DispatchQueue.main.sync {
                self.showBanner(success: true)
            }
        }
    }
}
