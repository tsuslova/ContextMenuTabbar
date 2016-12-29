//
//  SubmenuItem.swift
//  SubmenuTabbar
//
//  Created by Toto on 15.12.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import UIKit

class SubmenuItem: NSObject {
    
    var image: UIImage!
    var selectedImage: UIImage!
    
    struct MenuDataConf {
        static let imageKey = "image"
        static let selectedImageSuffix = "_selected"
    }
        
    init(dictionary: Dictionary<String, Any>) {
        let imageName = dictionary[MenuDataConf.imageKey] as! String
        image = UIImage(named: imageName)!
        let selectedImageName = imageName.appending(MenuDataConf.selectedImageSuffix)
        selectedImage = UIImage(named: selectedImageName)!
    
    }
}
