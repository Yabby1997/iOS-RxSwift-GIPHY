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
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    
        self.searchController.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ (text) -> Bool in
                text != ""
            })
            .subscribe(onNext: { text in
                let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                self.searchController.searchBar.endEditing(true)
                self.searchController.isActive = false
                self.navigationItem.title = text
                self.viewModel.searchGif(keyword: query)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.gifObservable
            .observe(on: MainScheduler.instance)
            .filter({ gifs in
                self.resultCollectionView.backgroundView?.isHidden = gifs.count > 0 ? true : false
                self.resultCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: false)
                return true
            })
            .bind(to: resultCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: SearchCollectionViewCell.self)) { index, item, cell in
                
                cell.backgroundColor = .systemGray5
                Nuke.loadImage(with: item.thumbnailURL, options: nukeOptions, into: cell.thumbnailImageView)
                cell.thumbnailImageView.contentMode = .scaleAspectFill
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Helpers
    
    func configureUI() {
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
        
        self.searchController.searchBar.placeholder = "검색어를 입력해주세요."
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.automaticallyShowsScopeBar = true
        
        self.navigationItem.searchController = searchController
        self.resultCollectionView.backgroundView = EmptyResultView(image: UIImage(systemName: "info.circle")!, title: "검색결과가 없습니다.", message: "다른 검색어로 시도해주세요.")
        
        resultCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        self.searchController.searchBar.delegate = self
        self.resultCollectionView.keyboardDismissMode = .onDrag
    }
    
    // MARK: - IBActions
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.searchController.isActive = true
    }
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
        self.searchController.searchBar.endEditing(true)
    }
}
