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
    
    // MARK: - IBActions
    
    @IBAction func didTapCopyButton(_ sender: Any) {
        let successBanner = NotificationBanner(subtitle: "Clipboard에 복사완료!", style: .success)
        let failedBanner = NotificationBanner(subtitle: "Clipboard에 복사실패", style: .danger)
        successBanner.haptic = .heavy
        failedBanner.haptic = .heavy
        
        DispatchQueue.global().async {
            guard let gif = self.gif else {
                DispatchQueue.main.sync {
                    failedBanner.show()
                }
                return
            }
            
            guard let data = NSData(contentsOf: gif.originalURL) else {
                DispatchQueue.main.sync {
                    failedBanner.show()
                }
                return
            }
            UIPasteboard.general.setData(data as Data, forPasteboardType: "com.compuserve.gif")
            DispatchQueue.main.sync {
                successBanner.show()
            }
        }
    }
}
