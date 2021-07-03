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
import Hero
import SnapKit

class SearchViewController: UIViewController {

    // MARK: - Properties
    
    let cellIdentifier: String = "SearchViewCell"
    var isLoading: Bool = true
    
    var viewModel: SearchViewModel = SearchViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    
    lazy var emptyResultView: EmptyResultView = {
        let resultView = EmptyResultView(image: UIImage(systemName: "info.circle")!, title: "검색결과가 없습니다.", message: "다른 검색어로 시도해주세요.")
        return resultView
    }()
    
    lazy var loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
    var loadingView: LoadingReusableView?
    
    lazy var resultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingReusableView")
        collectionView.backgroundView = self.emptyResultView
        collectionView.keyboardDismissMode = .onDrag
        collectionView.refreshControl = self.refreshControl
        collectionView.backgroundColor =  UIColor.systemBackground
        
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색어를 입력해주세요."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        
        return searchController
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshResults), for: .valueChanged)
        
        return refreshControl
    }()
    
    lazy var searchButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem()
        barButton.image = UIImage(systemName: "magnifyingglass")
        
        return barButton
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
        self.bindUI()
    }

    // MARK: - Helpers
    
    func configureUI() {
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
        
        self.navigationController?.isHeroEnabled = true
        self.navigationController?.heroNavigationAnimationType = .fade
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationItem.rightBarButtonItem = self.searchButton
        
        self.resultCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.view.addSubview(resultCollectionView)
        
        self.resultCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.topMargin)
            $0.left.equalTo(self.view.snp.left)
            $0.right.equalTo(self.view.snp.right)
            $0.bottom.equalTo(self.view.snp.bottomMargin)
        }
    }
    
    func bindUI() {
        self.searchController.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter({ (text) -> Bool in
                text != ""
            })
            .subscribe(onNext: { text in
                let query = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                self.resultCollectionView.setContentOffset(CGPoint(x:0,y:0), animated: false)
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
                return true
            })
            .bind(to: resultCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: GifCollectionViewCell.self)) { index, item, cell in

                cell.backgroundColor = .systemGray5

                let dataSaveOption = UserDefaults.standard.bool(forKey: "DataSave")
                let thumbnailURL = dataSaveOption ? item.smallThumbnailURL : item.thumbnailURL

                Nuke.loadImage(with: thumbnailURL, options: nukeOptions, into: cell.thumbnailImageView)
                cell.thumbnailImageView.contentMode = .scaleAspectFill
                cell.thumbnailImageView.heroID = item.id
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - IBActions
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        self.searchController.isActive = true
    }
    
    @objc func refreshResults() {
        self.viewModel.refreshGif()
        self.refreshControl.endRefreshing()
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController else { return }
        
        detailViewController.gif = self.viewModel.gifObservable.value[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.loadingIndicator.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.loadingIndicator.stopAnimating()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
            self.loadingView = aFooterView
            self.loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
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

extension SearchViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
}
