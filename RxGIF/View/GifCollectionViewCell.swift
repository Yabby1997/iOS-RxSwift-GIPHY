//
//  GIFCollectionViewCell.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/05.
//

import UIKit
import FLAnimatedImage

class GifCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    lazy var thumbnailImageView: FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()

    // MARK: - LifeCycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        self.addSubview(self.thumbnailImageView)
        
        self.thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top)
            $0.bottom.equalTo(self.snp.bottom)
            $0.left.equalTo(self.snp.left)
            $0.right.equalTo(self.snp.right)
        }
    }
}
