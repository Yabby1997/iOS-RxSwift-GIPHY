//
//  DetailViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/06.
//

import UIKit
import FLAnimatedImage

class DetailViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        self.gifImageView.contentMode = .scaleAspectFit
    }
    
    
    // MARK: - IBActions
    
}
