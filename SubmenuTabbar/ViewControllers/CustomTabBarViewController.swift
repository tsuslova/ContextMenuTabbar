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
        guard tabIndex < viewControllersClasses.count else {
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
        if currentViewController != nil {
            currentViewController.view.removeFromSuperview()
            currentViewController.removeFromParentViewController()
        }
        
        let className = viewControllersClasses[tabIndex]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: className) 
        
        mainView.addSubview(viewController.view)
        self.addChildViewController(viewController)
        currentViewController = viewController
    }
    
}
