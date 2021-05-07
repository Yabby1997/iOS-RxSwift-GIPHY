//
//  DetailViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import UIKit
import FLAnimatedImage
import Nuke

class DetailViewController: UIViewController {

    // MARK: - Properties
    var gif: Gif?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var trendingLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        guard let gif = self.gif else { return }
        Nuke.loadImage(with: gif.originalURL, options: nukeOptions, into: self.gifImageView)
        self.titleLabel.text = gif.title
        self.trendingLabel.text = gif.trendingDate
        self.sourceLabel.text = gif.source
    }
    
    // MARK: - IBActions
    
    @IBAction func didTapCopyButton(_ sender: Any) {
        DispatchQueue.global().async {
            guard let gif = self.gif else { return }
            
            let data = NSData(contentsOf: gif.originalURL)
            UIPasteboard.general.setData(data! as Data, forPasteboardType: "com.compuserve.gif")
        }
    }
}
