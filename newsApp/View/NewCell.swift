//
//  NewCell.swift
//  newsApp
//
//  Created by оля on 04.12.2020.
//

import UIKit

class NewCell: UITableViewCell {

    let queryService = QueryService()
    
    static let identifier = "NewCell"
    
    @IBOutlet weak var newImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var DescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        sourceLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
        authorLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption2)
        
        titleLabel.numberOfLines = 0
        authorLabel.numberOfLines = 0
        sourceLabel.numberOfLines = 0
        DescriptionLabel.numberOfLines = 0
    }
    
    
    func configure(new: New){

        if let imgData = new.imageData{
            newImageView?.image = UIImage(data: imgData)
        }
        
        titleLabel?.text = new.title
        authorLabel?.text =  new.author
        sourceLabel?.text = new.source
        DescriptionLabel?.text = new.description
    }
}
