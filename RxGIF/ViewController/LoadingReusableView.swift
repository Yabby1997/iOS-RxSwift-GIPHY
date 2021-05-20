//
//  LoadingReusableView.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/20.
//

import UIKit

class LoadingReusableView: UICollectionReusableView {

    // MARK: - Properties
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycles
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
