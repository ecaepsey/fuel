//
//  ReviewsTableViewCell.swift
//  Reviews
//
//  Created by Dastan on 21/2/23.
//

import UIKit
import AppStoreConnect_Swift_SDK

class ReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewTitle: UILabel!
    @IBOutlet weak var reviewBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func labelSetup() {
        reviewTitle.font = UIFont(name: "FiraSans-Medium", size: 16)
        reviewTitle.textColor = UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        reviewTitle.textAlignment = .left
        
        reviewBody.font = UIFont(name: "FiraSans-Regular", size: 14)
        reviewBody.textColor = UIColor(red: 0.563, green: 0.563, blue: 0.563, alpha: 1)
        reviewBody.textAlignment = .left
        
        layer.cornerRadius = 12
        clipsToBounds = true
        layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    }
    
    func initialSetup(article: CustomerReview) {
        if let title = article.attributes?.title {
            reviewTitle.text = title
        }
        
        if let body = article.attributes?.body {
            reviewBody.text = body
        }
    }
    
}
