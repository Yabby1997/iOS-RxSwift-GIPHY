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
        
        self.initialSettings()
        self.configureUI()
    }
    
    // MARK: - Helpers
    
    func initialSettings() {
        let defaults = UserDefaults.standard
        
        defaults.register(
            defaults: [
                "DisplayImageCount": 30,
                "ImageRatingIndex": 0,
                "HideNotch": true,
                "DataSave": false
            ]
        )
    }
    
    func configureUI() {
        let defaults = UserDefaults.standard
        
        self.currentDisplayImageCountLabel.text = "\(defaults.integer(forKey: "DisplayImageCount"))장"
        self.displayImageCountSlider.value = Float(defaults.integer(forKey: "DisplayImageCount"))
        self.imageRatingSegmentedController.selectedSegmentIndex = defaults.integer(forKey: "ImageRatingIndex")
        self.hideNotchSwitch.isOn = defaults.bool(forKey: "HideNotch")
        self.dataSaveSwitch.isOn = defaults.bool(forKey: "DataSave")
    }
    
    // MARK: - IBActions
    
    @IBAction func displayImageCountSliderValueChanged(_ sender: Any) {
        let defaults = UserDefaults.standard
        let value = Int(self.displayImageCountSlider.value)
        
        self.currentDisplayImageCountLabel.text = "\(value)장"
        defaults.setValue(value, forKey: "DisplayImageCount")
    }
    
    @IBAction func imageRatingSegmentControllValueChanged(_ sender: Any) {
        let defaults = UserDefaults.standard
        let value = self.imageRatingSegmentedController.selectedSegmentIndex
        
        defaults.setValue(value, forKey: "ImageRatingIndex")
    }
    
    @IBAction func hideNotchSwitchToggled(_ sender: Any) {
        let defaults = UserDefaults.standard
        let value = self.hideNotchSwitch.isOn
        
        defaults.setValue(value, forKey: "HideNotch")
    }
    
    @IBAction func dataSaveSwitchToggled(_ sender: Any) {
        let defaults = UserDefaults.standard
        let value = self.dataSaveSwitch.isOn
        
        defaults.setValue(value, forKey: "DataSave")
    }
}
