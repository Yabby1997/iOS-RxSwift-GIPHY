//
//  SettingsViewController.swift
//  RxGIF
//
//  Created by Seunghun Yang on 2021/05/17.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    // MARK: - Properties
    
    let cellIdentifier = "SettingsCell"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var settingsTableView: UITableView!

    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.settingsTableView.dataSource = self
        self.settingsTableView.delegate = self
    }
    
    // MARK: - Helpers
    
    // MARK: - IBActions
    
}

// MARK: - UITableViewDataSource

extension SettingsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Search: return SearchOptions.allCases.count
        case .Image : return ImageOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.settingsTableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! SettingsTableViewCell
        
        guard let section = SettingsSection(rawValue: indexPath.section) else { return cell }
        
        title = ""
        
        switch section {
        case .Search: title = SearchOptions(rawValue: indexPath.row)?.description
        case .Image : title = ImageOptions(rawValue: indexPath.row)?.description
        }
        
        cell.titleLabel?.text = title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray5
        
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.text = SettingsSection(rawValue: section)?.description
        view.addSubview(title)
        
        title.snp.makeConstraints {
            $0.centerY.equalTo(view.snp.centerY)
            $0.left.equalTo(view.snp.left).offset(10)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension SettingsViewController : UITableViewDelegate {
    
}
