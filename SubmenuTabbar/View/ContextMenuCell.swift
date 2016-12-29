//
//  ContextMenuCell.swift
//  
//
//  Created by Toto on 16.12.16.
//
//

import UIKit

class ContextMenuCell: UITableViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    var item: SubmenuItem? {
        didSet {
            if (menuImageView != nil) {
                menuImageView.image = item?.image
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = true
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        layer.shadowColor = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1).cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.5
        menuImageView.image = item?.image
    }
}


extension ContextMenuCell: YALContextMenuCell{
    
    func animatedIcon() -> UIView! {
        return self.menuImageView
    }
    
    func animatedContent() -> UIView! {
        return nil
    }
}
