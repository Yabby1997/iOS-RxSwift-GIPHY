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
import RxDataSources
import Nuke
import NukeFLAnimatedImagePlugin
import Hero

class SearchViewController: UIViewController {

    // MARK: - Properties
    
    let cellIdentifier: String = "SearchViewCell"
    var isLoading: Bool = true
    
    var viewModel: SearchViewModel = SearchViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    
    let searchController = UISearchController(searchResultsController: nil)
    let refreshControl = UIRefreshControl()
    var loadingView: LoadingReusableView?
    
    typealias DataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Gif>>
    lazy var dataSource : DataSource = {
        let dataSource = DataSource(
            configureCell: { _, collectionView, indexPath, item in
                let cell = self.resultCollectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! GifCollectionViewCell
                cell.backgroundColor = .systemGray5

                let dataSaveOption = UserDefaults.standard.bool(forKey: "DataSave")
                let thumbnailURL = dataSaveOption ? item.smallThumbnailURL : item.thumbnailURL

                Nuke.loadImage(with: thumbnailURL, options: nukeOptions, into: cell.thumbnailImageView)
                cell.thumbnailImageView.contentMode = .scaleAspectFill
                cell.thumbnailImageView.heroID = item.id
                
                return cell
            },
            configureSupplementaryView: { _, collectionView, kind, indexPath in
                switch kind {
                    case UICollectionView.elementKindSectionFooter:
                        let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingReusableView", for: indexPath) as! LoadingReusableView
                        return aFooterView
                    default:
                        return UICollectionReusableView()
                }
            })

        return dataSource
    }()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
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
            .map{ gifs in
                [SectionModel<String, Gif>(model: "", items: gifs)]
            }
            .bind(to: resultCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }

    // MARK: - Helpers
    
    func configureUI() {
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
        
        self.navigationController?.isHeroEnabled = true
        
        self.searchController.searchBar.placeholder = "검색어를 입력해주세요."
        self.searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        self.resultCollectionView.backgroundView = EmptyResultView(image: UIImage(systemName: "info.circle")!, title: "검색결과가 없습니다.", message: "다른 검색어로 시도해주세요.")
        
        self.resultCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.searchController.searchBar.delegate = self
        self.resultCollectionView.keyboardDismissMode = .onDrag
        
        self.refreshControl.addTarget(self, action: #selector(self.refreshResults), for: .valueChanged)
        self.resultCollectionView.refreshControl = self.refreshControl
        
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        self.resultCollectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingReusableView")
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
