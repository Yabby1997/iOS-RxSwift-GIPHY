//
//  RandomViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/10.
//

import UIKit
import FLAnimatedImage
import RxSwift
import RxCocoa
import Nuke
import NukeFLAnimatedImagePlugin
import SnapKit

class RandomViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: RandomViewModel = RandomViewModel()
    let disposeBag = DisposeBag()
    
    var notchIgnoredTopConstraint: Constraint?
    var topConstraint: Constraint?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.getRandomGif()
        
        self.configureUI()
        
        self.viewModel.gifObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { gif in
                Nuke.loadImage(with: gif.originalURL, options: nukeOptions, into: self.gifImageView)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let ignoreNotchOption = UserDefaults.standard.bool(forKey: "IgnoreNotch")
        if(ignoreNotchOption) {
            self.topConstraint?.deactivate()
            self.notchIgnoredTopConstraint?.activate()
        } else {
            self.notchIgnoredTopConstraint?.deactivate()
            self.topConstraint?.activate()
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        self.gifImageView.contentMode = .scaleAspectFit
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.gifImageViewTapped))
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.gifImageViewSwiped))
        swipeGesture.direction = .left
        self.gifImageView.addGestureRecognizer(tapGesture)
        self.gifImageView.addGestureRecognizer(swipeGesture)
        self.gifImageView.isUserInteractionEnabled = true
        
        self.gifImageView.snp.makeConstraints {
            self.notchIgnoredTopConstraint = $0.top.equalTo(self.view.snp.top).constraint
        }
        self.notchIgnoredTopConstraint?.deactivate()
        self.gifImageView.snp.makeConstraints {
            self.topConstraint = $0.top.equalTo(UIApplication.shared.windows[0].safeAreaInsets.top).constraint
        }
    }
    
    // MARK: - Actions
    @objc func gifImageViewTapped() {
        self.gifImageView.contentMode = self.gifImageView.contentMode == .scaleAspectFit ? .scaleAspectFill : .scaleAspectFit
    }
    
    @objc func gifImageViewSwiped(_ sender: UISwipeGestureRecognizer) {
        self.viewModel.getRandomGif()
    }
}
