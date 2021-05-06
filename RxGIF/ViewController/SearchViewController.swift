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

class SearchViewController: UIViewController {

    // MARK: - Properties
    
    let cellIdentifier: String = "SearchViewCell"
    var viewModel: SearchViewModel = SearchViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.gifObservable
            .observeOn(MainScheduler.instance)
            .bind(to: resultCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: SearchCollectionViewCell.self)) { index, item, cell in
                
                do {
                    let gifData = try Data(contentsOf: item.thumbnailURL)
                    cell.thumbnailImageView.animatedImage = FLAnimatedImage(gifData: gifData)
                } catch {
                    let gifData = NSDataAsset(name: "nyan")
                    cell.thumbnailImageView.animatedImage = FLAnimatedImage(gifData: gifData?.data)
                }
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
