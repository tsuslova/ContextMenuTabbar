//
//  TabsSubmenuProvider.swift
//  SubmenuTabbar
//
//  Created by Toto on 15.12.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import UIKit

class TabsSubmenuProvider: NSObject {
    //Plist keys:
    static let kTabsKey = "OrderedTabs"
    
    
    // MARK: - Static interface:
    
    static func tabViewControllersIds() -> Array<String>{
        let tabsData = submenuData()
        return tabsData[TabsSubmenuProvider.kTabsKey] as! Array<String>
    }
    
    static var itemsCache = Dictionary<String, Array<SubmenuItem>>()
    
    static func submenuItemsForVCId(vcIdentifier: String) -> Array<SubmenuItem>{
        var submenuItems = itemsCache[vcIdentifier]
        
        if submenuItems != nil {
            return submenuItems!
        }
        
        submenuItems = Array<SubmenuItem>()
        
        let submenuItemsDictionary = submenuData()[vcIdentifier] as! Array<Dictionary<String, Any>>
        
        for dict in submenuItemsDictionary {
            let item = SubmenuItem(dictionary: dict)
            submenuItems?.append(item)
        }
        itemsCache.updateValue(submenuItems!, forKey: vcIdentifier)
        
        return submenuItems!
    }
    
    static func select(item:SubmenuItem, forVCId vcIdentifier: String){
        //Assume that menu items list is not changed often, so it's not critical to perform the item
        //serialization - it's enough to store item index
        let submenuItems = submenuItemsForVCId(vcIdentifier: vcIdentifier)
        let itemIndex = submenuItems.index(of: item)
        UserDefaults.standard.set(itemIndex, forKey: selectedItemKey(forVCId: vcIdentifier))
        UserDefaults.standard.synchronize()

    }
    
    static func selectedItem(forVCId vcIdentifier:String) -> SubmenuItem {
        let selectedItemIndex = UserDefaults.standard.object(forKey: selectedItemKey(forVCId: vcIdentifier)) as? Int
        let submenuItems = submenuItemsForVCId(vcIdentifier: vcIdentifier)
        
        guard selectedItemIndex != nil && submenuItems.count > selectedItemIndex! else {
            print("Saved selected item index out of current range - return first element")
            return submenuItems.first!
        }
        return submenuItems[selectedItemIndex!]
    }
    
    // MARK: - Implementation:
    private static var dataDictionary: Dictionary<String, Any>?
    private static func submenuData() -> Dictionary<String, Any>{
        if dataDictionary == nil{
            if let path = Bundle.main.path(forResource: "SubmenuByTab", ofType: "plist"){
                let url = URL(fileURLWithPath: path)
                let data = try! Data(contentsOf: url)
                dataDictionary = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as! Dictionary<String, Any>
                }
            }
        return dataDictionary!
    }
        
    //NSUserDefaults key:
    static let kSelectedItemKey = "SelectedItemKey"
    private static func selectedItemKey(forVCId vcIdentifier: String) -> String {
        return kSelectedItemKey + "_" + vcIdentifier
    }
}
