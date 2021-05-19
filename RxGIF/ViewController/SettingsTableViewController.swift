//
//  SettingsTableViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/17.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    // MARK: - Properties
    let languages = ["English", "Korean", "Japanese", "French", "Germany"]
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var currentFetchLimitLabel: UILabel!
    @IBOutlet weak var fetchLimitSlider: UISlider!
    @IBOutlet weak var imageRatingSegment: UISegmentedControl!
    @IBOutlet weak var languageTextField: CustomTextField!
    @IBOutlet weak var ignoreNotchSwitch: UISwitch!
    @IBOutlet weak var dataSaveSwitch: UISwitch!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSettings()
        self.configureUI()
        self.configureLanguagePicker()
    }
    
    // MARK: - Helpers
    
    func initialSettings() {
        let userDefaults = UserDefaults.standard
        
        userDefaults.register(
            defaults: [
                "Limit": 30,
                "RatingIndex": 0,
                "Rating": "g",
                "Language": "en",
                "IgnoreNotch": true,
                "DataSave": false
            ]
        )
    }
    
    func configureUI() {
        let userDefaults = UserDefaults.standard
        
        self.currentFetchLimitLabel.text = "\(userDefaults.integer(forKey: "Limit"))장"
        self.fetchLimitSlider.value = Float(userDefaults.integer(forKey: "Limit"))
        self.imageRatingSegment.selectedSegmentIndex = userDefaults.integer(forKey: "RatingIndex")
        self.ignoreNotchSwitch.isOn = userDefaults.bool(forKey: "IgnoreNotch")
        self.dataSaveSwitch.isOn = userDefaults.bool(forKey: "DataSave")
        
        self.languageTextField.tintColor = .clear
    }
    
    func configureLanguagePicker() {
        let languagePicker = UIPickerView()
        let toolBar = UIToolbar()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissPicker))
        
        languagePicker.delegate = self
        languagePicker.dataSource = self
        languageTextField.delegate = self
        
        self.languageTextField.inputView = languagePicker
        
        toolBar.sizeToFit()
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.languageTextField.inputAccessoryView = toolBar
    }
    
    // MARK: - IBActions
    
    @IBAction func fetchLimitSliderValueChanged(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        let value = Int(self.fetchLimitSlider.value)
        
        self.currentFetchLimitLabel.text = "\(value)장"
        userDefaults.setValue(value, forKey: "Limit")
    }
    
    @IBAction func imageRatingSegmentValueChanged(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        let index = self.imageRatingSegment.selectedSegmentIndex
        let value = self.imageRatingSegment.titleForSegment(at: index)
        
        userDefaults.setValue(index, forKey: "RatingIndex")
        userDefaults.setValue(value, forKey: "Rating")
    }
    
    @IBAction func ignoreNotchSwitchToggled(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        let value = self.ignoreNotchSwitch.isOn
        
        userDefaults.setValue(value, forKey: "IgnoreNotch")
    }
    
    @IBAction func dataSaveSwitchToggled(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        let value = self.dataSaveSwitch.isOn
        
        userDefaults.setValue(value, forKey: "DataSave")
    }
    
    @objc func dismissPicker() {
        self.view.endEditing(true)
    }
}

// MARK: - UIPickerViewDataSource

extension SettingsTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.languages[row]
    }
}

// MARK: - UIPickerViewDelegate

extension SettingsTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let userDefaults = UserDefaults.standard
        let value = self.languages[row]
        
        self.languageTextField.text = value
        userDefaults.setValue(value, forKey: "Language")
    }
}

// MARK: - UITextFieldDelegate

extension SettingsTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
