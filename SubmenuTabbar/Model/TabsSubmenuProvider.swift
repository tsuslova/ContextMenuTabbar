//
//  TabsSubmenuProvider.swift
//  SubmenuTabbar
//
//  Created by Toto on 15.12.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import UIKit

class TabsSubmenuProvider: NSObject {
    
    //static let sharedInstance = TabsSubmenuProvider()
    
    //Plist keys:
    static let kTabsKey = "OrderedTabs"
    
    
    // MARK: - Static interface:
    
    static func tabViewControllersIds() -> Array<String>{
        let tabsData = self.submenuData()
        return tabsData[TabsSubmenuProvider.kTabsKey] as! Array<String>
    }
    
    static var itemsCache = Dictionary<String, Array<SubmenuItem>>()
    
    static func submenuItemsForVCId(vcIdentifier: String) -> Array<SubmenuItem>{
        var submenuItems = itemsCache[vcIdentifier]
        
        if submenuItems != nil {
            return submenuItems!
        }
        
        submenuItems = Array<SubmenuItem>()
        
        let submenuItemsDictionary = self.submenuData()[vcIdentifier] as! Array<Dictionary<String, Any>>
        
        for dict in submenuItemsDictionary {
            let item = SubmenuItem(dictionary: dict)
            submenuItems?.append(item)
        }
        itemsCache.updateValue(submenuItems!, forKey: vcIdentifier)
        
        return submenuItems!
    }
    
    //TODO
    //    + (NSArray*)submenuItemsForVCId:(NSString*)vcIdentifier{
    //    static NSMutableDictionary *itemsCache = nil
    //    if (!itemsCache){
    //    itemsCache = [NSMutableDictionary dictionary]
    //    }
    //
    //    NSMutableArray *submenuItems = itemsCache[vcIdentifier]
    //    if (submenuItems){
    //    return submenuItems
    //    }
    //    submenuItems = [NSMutableArray array]
    //    NSArray *submenuItemsDictionary = [self loadSubmenuData][vcIdentifier]
    //
    //    for (NSDictionary *dict in submenuItemsDictionary){
    //    SubmenuItem *item = [[SubmenuItem alloc] initWithDictionary:dict]
    //    [submenuItems addObject:item]
    //    }
    //    [itemsCache setObject:submenuItems forKey:vcIdentifier]
    //    return submenuItems
    //    }

    
    // MARK: - Implementation:
    private static var dataDictionary: Dictionary<String, Any>?
    private static func submenuData() -> Dictionary<String, Any>{
        if self.dataDictionary == nil{
            if let path = Bundle.main.path(forResource: "SubmenuByTab", ofType: "plist"){
                let url = URL(fileURLWithPath: path)
                let data = try! Data(contentsOf: url)
                self.dataDictionary = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as! Dictionary<String, Any>
                }
            }
        return self.dataDictionary!
    }
    
}
