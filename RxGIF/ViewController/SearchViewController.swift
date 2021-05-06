//
//  ViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/05.
//

import UIKit
import FLAnimatedImage
import RxCocoa
import RxSwift
import Nuke
import NukeFLAnimatedImagePlugin

class SearchViewController: UIViewController {

    // MARK: - Properties
    
    let cellIdentifier: String = "SearchViewCell"
    var viewModel: SearchViewModel = SearchViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    
    let nukeOptions = ImageLoadingOptions(
        transition: .fadeIn(duration: 0.45)
    )
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
        
        self.viewModel.gifObservable
            .observe(on: MainScheduler.instance)
            .bind(to: resultCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: SearchCollectionViewCell.self)) { index, item, cell in
                
                cell.backgroundColor = .systemGray5
                Nuke.loadImage(with: item.thumbnailURL, options: self.nukeOptions, into: cell.thumbnailImageView)
                cell.thumbnailImageView.contentMode = .scaleAspectFill
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Helpers
    
    
    // MARK: - IBActions

}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "segueToDetail", sender: self)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 4) / 3
        
        return CGSize(width: width, height: width)
    }
}
