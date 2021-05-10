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
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
        
        resultCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        self.searchBar.delegate = self
        
        self.resultCollectionView.keyboardDismissMode = .onDrag
        
        self.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ (text) -> Bool in
                text != ""
            })
            .map({ text in
                text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            })
            .subscribe(onNext: { text in
                self.searchBar.endEditing(true)
                self.viewModel.searchGif(keyword: text)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.gifObservable
            .observe(on: MainScheduler.instance)
            .bind(to: resultCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: SearchCollectionViewCell.self)) { index, item, cell in
                
                cell.backgroundColor = .systemGray5
                Nuke.loadImage(with: item.thumbnailURL, options: nukeOptions, into: cell.thumbnailImageView)
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
        guard let detailViewController = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
        
        detailViewController.gif = self.viewModel.gifObservable.value[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
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

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}
