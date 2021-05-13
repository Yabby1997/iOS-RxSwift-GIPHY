//
//  TrendingViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/13.
//

import UIKit
import FLAnimatedImage
import RxCocoa
import RxSwift
import Nuke
import NukeFLAnimatedImagePlugin

class TrendingViewController: UIViewController {

    // MARK: - Properties
    
    let cellIdentifier: String = "TrendingViewCell"
    var viewModel: SearchViewModel = SearchViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
        self.configureUI()
        
        self.viewModel.searchGif(keyword: "Spongebob")
        
        self.viewModel.gifObservable
            .observe(on: MainScheduler.instance)
            .bind(to: resultCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: GifCollectionViewCell.self)) { index, item, cell in
                
                cell.backgroundColor = .systemGray5
                Nuke.loadImage(with: item.thumbnailURL, options: nukeOptions, into: cell.thumbnailImageView)
                cell.thumbnailImageView.contentMode = .scaleAspectFill
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Helpers
    
    func configureUI() {
        self.resultCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate

extension TrendingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
        
        detailViewController.gif = self.viewModel.gifObservable.value[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrendingViewController: UICollectionViewDelegateFlowLayout {

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
