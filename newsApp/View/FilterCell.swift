//
//  FilterCell.swift
//  newsApp
//
//  Created by оля on 06.12.2020.
//

import UIKit

class FilterCell: UITableViewCell {

    static let identifier = "FilterCell"


    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
