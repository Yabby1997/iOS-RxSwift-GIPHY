//
//  ViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/05.
//

import UIKit
import FLAnimatedImage

class SearchViewController: UIViewController {

    // MARK: - Properties
    
    let cellIdentifier: String = "SearchViewCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
    }

    // MARK: - Helpers
    
    
    // MARK: - IBACtions

}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! SearchCollectionViewCell

        let gifData = NSDataAsset(name: "nyan")
        let gif = FLAnimatedImage(gifData: gifData?.data)
        cell.thumbnailImageView.animatedImage = gif
        cell.thumbnailImageView.contentMode = .scaleAspectFill
        cell.backgroundColor = .lightGray

        return cell
    }
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
