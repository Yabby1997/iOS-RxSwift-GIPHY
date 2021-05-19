//
//  SettingsTableViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/17.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    // MARK: - Properties
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var currentDisplayImageCountLabel: UILabel!
    @IBOutlet weak var displayImageCountSlider: UISlider!
    @IBOutlet weak var imageRatingSegmentedController: UISegmentedControl!
    @IBOutlet weak var hideNotchSwitch: UISwitch!
    @IBOutlet weak var dataSaveSwitch: UISwitch!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    
    // MARK: - IBActions
    @IBAction func displayImageCountSliderChanged(_ sender: Any) {
        print("표시 이미지 수 : \(self.displayImageCountSlider.value)")
    }
    
    @IBAction func imageRatingSegmentControllChanged(_ sender: Any) {
        print("이미지 등급 : \(self.imageRatingSegmentedController.selectedSegmentIndex)")
    }
    
    @IBAction func hideNotchSwitchToggled(_ sender: Any) {
        print("노치 무시 : \(self.hideNotchSwitch.isOn)")
    }
    
    @IBAction func dataSaveSwitchToggled(_ sender: Any) {
        print("데이터 절약 : \(self.dataSaveSwitch.isOn)")
    }
}
