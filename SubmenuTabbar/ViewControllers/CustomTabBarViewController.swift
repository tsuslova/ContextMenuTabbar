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
    
    @IBAction func showSubmenu(_ sender: UIButton) {
        
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
    
}

// MARK: - Menu datasource/delegate extension

extension CustomTabBarViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContextMenuCell", for: indexPath)
        let items = TabsSubmenuProvider.submenuItemsForVCId(vcIdentifier: self.currentViewController.restorationIdentifier!)
        let object = items[indexPath.row] as SubmenuItem
//        cell.titleLabel.text = object.image.name

        return cell
    }
    
}

