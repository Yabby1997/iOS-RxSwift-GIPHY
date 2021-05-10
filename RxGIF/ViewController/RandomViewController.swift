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

class RandomViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: RandomViewModel = RandomViewModel()
    let disposeBag = DisposeBag()
    
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
    
    // MARK: - Helpers
    
    func configureUI() {
        self.gifImageView.contentMode = .scaleAspectFit
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.gifImageViewTapped))
        self.gifImageView.addGestureRecognizer(tapGesture)
        self.gifImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    @objc func gifImageViewTapped() {
        self.viewModel.getRandomGif()
    }
    
}
