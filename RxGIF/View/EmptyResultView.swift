//
//  EmptyResultView.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/10.
//

import UIKit
import Foundation
import SnapKit

class EmptyResultView: UIView {
    // MARK: - Properties
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - LifeCyclse
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    init(image: UIImage, title: String, message: String) {
        super.init(frame: .zero)
        self.configureUI()
        self.imageView.image = image
        self.titleLabel.text = title
        self.messageLabel.text = message
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(messageLabel)
        
        self.imageView.snp.makeConstraints {
            $0.centerX.equalTo(self.snp.centerX)
            $0.width.equalTo(50)
            $0.height.equalTo(self.imageView.snp.width)
            $0.top.equalTo(self.snp.top).offset(100)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.imageView.snp.bottom).offset(20)
            $0.left.equalTo(self.snp.left).offset(20)
            $0.right.equalTo(self.snp.right).offset(-20)
        }
        
        self.messageLabel.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            $0.left.equalTo(self.snp.left).offset(20)
            $0.right.equalTo(self.snp.right).offset(-20)
        }
    }
}
