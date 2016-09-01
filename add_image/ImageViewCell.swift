//
//  ImageViewCell.swift
//  add_image
//
//  Created by North on 9/1/2559 BE.
//  Copyright © 2559 North. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImageValue(img: Images) {
        self.itemImageView.image = img.getImage()
    }
    
}
