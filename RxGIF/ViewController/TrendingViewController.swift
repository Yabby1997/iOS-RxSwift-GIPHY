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
    var viewModel: TrendingViewModel = TrendingViewModel()
    var disposeBag: DisposeBag = DisposeBag()
    
    lazy var resultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(GifCollectionViewCell.self, forCellWithReuseIdentifier: self.cellIdentifier)
        collectionView.keyboardDismissMode = .onDrag
        collectionView.refreshControl = self.refreshControl
        collectionView.backgroundColor =  UIColor.systemBackground
        
        return collectionView
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refreshResults), for: .valueChanged)
        
        return refreshControl
    }()
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImagePipeline.Configuration.isAnimatedImageDataEnabled = true
        self.viewModel.fetchTrendingGif()
        self.configureUI()
        self.bindUI()
    }

    // MARK: - Helpers
    
    func configureUI() {
        self.navigationController?.isHeroEnabled = true
        self.navigationController?.heroNavigationAnimationType = .fade
        
        self.resultCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        self.view.addSubview(resultCollectionView)
        
        self.resultCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.snp.topMargin)
            $0.bottom.equalTo(self.view.snp.bottomMargin)
            $0.left.equalTo(self.view.snp.left)
            $0.right.equalTo(self.view.snp.right)
        }
    }
    
    func bindUI() {
        self.viewModel.gifObservable
            .observe(on: MainScheduler.instance)
            .bind(to: resultCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: GifCollectionViewCell.self)) { index, item, cell in
                
                cell.backgroundColor = .systemGray5
                
                let dataSaveOption = UserDefaults.standard.bool(forKey: "DataSave")
                let thumbnailURL = dataSaveOption ? item.smallThumbnailURL : item.thumbnailURL
                
                Nuke.loadImage(with: thumbnailURL, options: nukeOptions, into: cell.thumbnailImageView)
                cell.thumbnailImageView.heroID = item.id
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - IBActions
    
    @objc func refreshResults() {
        self.viewModel.fetchTrendingGif()
        self.refreshControl.endRefreshing()
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
