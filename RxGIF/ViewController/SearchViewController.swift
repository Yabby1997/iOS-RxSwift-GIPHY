//
//  ViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/05.
//

import UIKit

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)

        cell.backgroundColor = .red

        return cell
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
