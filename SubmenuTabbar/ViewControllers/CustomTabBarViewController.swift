//
//  CustomTabBarViewController.swift
//  SubmenuTabbar
//
//  Created by Toto on 05.12.16.
//  Copyright © 2016 Toto. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UIViewController {
    
    // MARK: - Configuration
    // List here all VCs storyboard ids, accessible from TabBar
    
    let viewControllersClasses = ["SettingsViewController",
                                  "StandingsViewController",
                                  "MapViewController",
                                  "PortfolioViewController"]
    
    var contextMenuTableView: YALContextMenuTableView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var submenuView: UIView!
    @IBOutlet weak var initialTabButton: UIButton!
    @IBOutlet weak var currentMenuImage: UIImageView!
    
    
    @IBOutlet weak var tabBarView: UIView!
    
    
    //Buttons for localisation:
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var standingsButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var portfolioButton: UIButton!
    
    @IBOutlet weak var submenuButton: UIButton!
        
    
    var currentViewController: UIViewController!
    lazy var currentBarButton: UIButton = self.initialTabButton
    
    // MARK: - VC lyfecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeToVCAtIndex(0)
    }
    
    // MARK: - IBActions
    @IBAction func tabButtonPressed(_ sender: UIButton) {
        let tabIndex = sender.tag
        let viewControllersIds = TabsSubmenuProvider.tabViewControllersIds()
        guard tabIndex < viewControllersIds.count else {
            print("Another method needed for menu button")
            return
        }
        changeToVCAtIndex(tabIndex)
        
        currentBarButton.isSelected = false
        currentBarButton = sender
        currentBarButton.titleLabel?.isHidden = false
        sender.isSelected = !sender.isSelected
        sender.titleLabel?.isHidden = true
    }
    
    
    struct MenuConf {
        static let animationDuration = CGFloat(0.15)
        static let cellIdentifier = "ContextMenuCell"
    }
    
    @IBAction func showSubmenu(_ sender: UIButton) {
        if contextMenuTableView == nil {
            contextMenuTableView = YALContextMenuTableView(tableViewDelegateDataSource: self)
            contextMenuTableView.animationDuration = MenuConf.animationDuration
            //TODO
//            contextMenuTableView.yalDelegate = self
            contextMenuTableView.menuItemsSide = .Right
            contextMenuTableView.menuItemsAppearanceDirection = .FromBottomToTop
            
            let nib = UINib(nibName:"ContextMenuCell", bundle:Bundle.main)
            contextMenuTableView.register(nib, forCellReuseIdentifier:MenuConf.cellIdentifier)
        } else {
            contextMenuTableView.reloadData()
        }
        contextMenuTableView.show(in: view, with: UIEdgeInsets.zero, animated: true)
    }
    
    
    // MARK: - Private VC logic
    private func changeToVCAtIndex(_ tabIndex: Int){
        let viewControllersIds = TabsSubmenuProvider.tabViewControllersIds()
        guard tabIndex < viewControllersIds.count else {
            print("Menu index out of tabViewControllersIds range")
            return
        }
        
        if currentViewController != nil {
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParentViewController()
        }
        
        let viewControllersId = viewControllersIds[tabIndex]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllersId)
        
        mainView.addSubview(viewController.view)
        self.addChildViewController(viewController)
        currentViewController = viewController
        
        //TODO:
        //        [self preselectSubmenuItem];
    }

    func submenuItem(forIndexPath indexPath: IndexPath) -> SubmenuItem? {
        let items = TabsSubmenuProvider.submenuItemsForVCId(vcIdentifier: self.currentViewController.restorationIdentifier!)
        //Map index for context menu:
        // 1. the menu displayed items upsidedown, to leave order like in plist invert it
        // 2. we add additional item to be displayed above tabbar since edge inset works improperly in context menu
        let itemIndex = items.count - indexPath.row
        if itemIndex == items.count {
            return nil
        }
        return items[itemIndex]

    }
}

// MARK: - Menu datasource/delegate extension

extension CustomTabBarViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view delegate
    @nonobjc func tableView(_ tableView: YALContextMenuTableView, didSelectRowAt indexPath: IndexPath) {
        tableView.dismis(with: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tabBarView.frame.size.height
    }
    
    // MARK: - Table view datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let items = TabsSubmenuProvider.submenuItemsForVCId(vcIdentifier: self.currentViewController.restorationIdentifier!)
        //+1 for empty cell to avoid ugly overlay in case of menu inset - assume it like a cancel button
        return items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuConf.cellIdentifier, for: indexPath) as! ContextMenuCell
        if let item = self.submenuItem(forIndexPath: indexPath) {
            cell.item = item
        }

        return cell
    }
    
}

