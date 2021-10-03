
//
//  NewsTableViewCell.swift
//  QuNews
//
//  Created by Никита Ничепорук on 9/28/21.
//  Copyright © 2021 Никита Ничепорук. All rights reserved.
//

import UIKit
import SDWebImage

final class NewsCellSource {
    let title: String
    let description: String?
    let author: String?
    let imageURL: URL?
    var imageData: Data? = nil
    
    init(title: String, description: String, author: String, imageURL: URL?) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.author = author
    }
}

final class NewsTableViewCell: UITableViewCell {
    @IBOutlet private weak var showMore: UIButton!
    @IBOutlet private weak var picture: UIImageView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    var showMoreClicked: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picture.layer.cornerRadius = 15
    }
    
    @IBAction func showMore(_ sender: Any) {
        showMoreClicked?()
    }
    
    func setup(with item: NewsCellSource) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        authorLabel.text = item.author
        picture.sd_setImage(with: item.imageURL, completed: nil)
        
        if picture.image == nil {
            picture.image = UIImage(named: "No image")
        }
        
        if item.author == nil || item.author?.isEmpty ?? true {
            authorLabel.text = "No author"
        } else {
            authorLabel.text = item.author
        }
        
        if item.description == nil || item.description?.isEmpty ?? true {
            descriptionLabel.text = "No description"
            showMore.isHidden = true
        } else {
            descriptionLabel.text = item.description
            showMore.isHidden = false
        }
    }
}
