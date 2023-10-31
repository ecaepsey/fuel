//
//  AppTableViewCell.swift
//  Reviews
//
//  Created by Dastan on 21/2/23.
//

import UIKit
import AppStoreConnect_Swift_SDK

class AppTableViewCell: UITableViewCell {

    @IBOutlet weak var appName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func nameSetup() {
        appName.font = UIFont(name: "FiraSans-Regular", size: 16)
        appName.textColor = UIColor(red: 0.137, green: 0.137, blue: 0.145, alpha: 1)
        appName.textAlignment = .left
    }
    
    func initialSetup(name: App) {
        if let nameApp = name.attributes?.name {
            appName.text = nameApp
        }
        
    }
    func initialSetupFilter(appsName: String) {
        appName.text = appsName
    }
    
}
