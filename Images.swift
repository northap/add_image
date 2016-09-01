//
//  Images.swift
//  add_image
//
//  Created by North on 9/1/2559 BE.
//  Copyright © 2559 North. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Images: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func setImage(img: UIImage) {
        
        let oldWidth = img.size.width
        let scaleFactor = 300.0 / oldWidth
        
        let newHeight = img.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth, newHeight), false, 1.0)
        img.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let data = UIImagePNGRepresentation(newImage)
        self.img = data
    }
    
    func getImage() -> UIImage {
        let img = UIImage(data: self.img!)!
        return img
    }
}
