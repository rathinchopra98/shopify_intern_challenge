//
//  TableViewCell.swift
//  shopify_intern_challenge
//
//  Created by user148961 on 1/15/19.
//  Copyright © 2019 user148961. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var collectionTitle: UILabel!
    @IBOutlet weak var textView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
