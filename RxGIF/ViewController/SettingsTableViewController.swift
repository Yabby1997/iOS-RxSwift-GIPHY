//
//  SettingsTableViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/17.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    // MARK: - Properties
    
    lazy var languagePicker : UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var toolBar : UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35))
        toolBar.sizeToFit()
        toolBar.setItems([self.barButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }()
    
    lazy var barButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dismissPicker))
        
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
        
        self.configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        self.languageTextField.inputView = languagePicker
        self.languageTextField.inputAccessoryView = toolBar
        self.languageTextField.tintColor = .clear
        
        let userDefaults = UserDefaults.standard
        self.currentFetchLimitLabel.text = "\(userDefaults.integer(forKey: "Limit"))장"
        self.fetchLimitSlider.value = Float(userDefaults.integer(forKey: "Limit"))
        self.imageRatingSegment.selectedSegmentIndex = userDefaults.integer(forKey: "RatingIndex")
        self.ignoreNotchSwitch.isOn = userDefaults.bool(forKey: "IgnoreNotch")
        self.dataSaveSwitch.isOn = userDefaults.bool(forKey: "DataSave")
        
        let language = userDefaults.string(forKey: "Language")
        guard let language = language else { return }
        self.languageTextField.text = Locale.current.localizedString(forLanguageCode: language) ?? language
        languagePicker.selectRow(languages.firstIndex(of: language) ?? 0, inComponent: 0, animated: false)
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
        self.languageTextField.resignFirstResponder()
    }
}

// MARK: - UIPickerViewDataSource

extension SettingsTableViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let value = languages[row]
        let fullname = Locale.current.localizedString(forLanguageCode: value)
        guard let fullname = fullname else { return value }
        return fullname
    }
}

// MARK: - UIPickerViewDelegate

extension SettingsTableViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let userDefaults = UserDefaults.standard
        let value = languages[row]
        userDefaults.setValue(value, forKey: "Language")
        
        let fullname = Locale.current.localizedString(forLanguageCode: value)
        guard let fullname = fullname else { return }
        self.languageTextField.text = fullname
    }
}
