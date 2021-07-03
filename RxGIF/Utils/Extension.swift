//
//  Extension.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/07/03.
//

import Foundation
import UIKit

extension UICollectionView {
    func isNearToBottomEdge(contentOffset: CGPoint) -> Bool {
        return contentOffset.y + self.frame.size.height + collectionViewStartLoadingOffset > self.contentSize.height
    }
}
