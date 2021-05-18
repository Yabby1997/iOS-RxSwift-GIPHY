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
import SnapKit
import Hero

class DetailViewController: UIViewController {

    // MARK: - Properties
    var gif: Gif?
    var banner: NotificationBanner?
    var initialInteractivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trendingLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialInteractivePopGestureRecognizerDelegate = self.navigationController?.interactivePopGestureRecognizer?.delegate
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self.initialInteractivePopGestureRecognizerDelegate
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let gif = self.gif else { return }
        Nuke.loadImage(with: gif.originalURL, options: nukeOptions, into: self.gifImageView)
        
        self.gifImageView.heroID = gif.id
        
        self.titleLabel.text = gif.title
        self.trendingLabel.text = gif.trendingDate
        self.sourceLabel.text = gif.source
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.toggleContentMode))
        self.gifImageView.addGestureRecognizer(tapGesture)
        self.gifImageView.isUserInteractionEnabled = true
        
        self.gifImageView.contentMode = .scaleAspectFill
        
        self.gifImageView.insetsLayoutMarginsFromSafeArea = false
        self.gifImageView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaInsets.top).offset(0)
        }
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
    
    // MARK: - Actions
    
    @objc func toggleContentMode() {
        self.gifImageView.contentMode = self.gifImageView.contentMode == .scaleAspectFit ? .scaleAspectFill : .scaleAspectFit
    }
}
