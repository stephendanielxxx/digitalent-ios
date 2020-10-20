//
//  HomeTabBarViewController.swift
//  Digitalent
//
//  Created by Teke on 15/10/20.
//

import UIKit
import MaterialComponents.MaterialBottomNavigation

class HomeTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let bottomNavBar = MDCBottomNavigationBar()
        
        bottomNavBar.delegate = self
        bottomNavBar.titleVisibility = MDCBottomNavigationBarTitleVisibility.selected
        bottomNavBar.alignment = MDCBottomNavigationBarAlignment.justifiedAdjacentTitles
        
        UITabBar.appearance().tintColor = UIColor(named: "color_2C64EE")
        
        let homeItem = UITabBarItem(title: "Home", image: UIImage(named: "ic_home"), tag: 0)
        let taskItem = UITabBarItem(title: "My Class", image: UIImage(named: "ic_class"), tag: 1)
        let profileItem = UITabBarItem(title: "Settings", image: UIImage(named: "ic_setting"), tag: 3)
        
        bottomNavBar.items = [homeItem, taskItem, profileItem]
        
        bottomNavBar.selectedItem = homeItem
        
        view.addSubview(bottomNavBar)
        
        let homeViewController = HomeViewController()
        let taskViewController = HomeViewController()
        let profile = HomeViewController()
        
        homeViewController.tabBarItem = homeItem
        taskViewController.tabBarItem = taskItem
        profile.tabBarItem = profileItem
        
        viewControllers = [homeViewController, taskViewController, profile]

    }

}

extension HomeTabBarViewController: MDCBottomNavigationBarDelegate{
    func bottomNavigationBar(_ bottomNavigationBar: MDCBottomNavigationBar, didSelect item: UITabBarItem) {
        self.selectedViewController = viewControllers![item.tag]
    }
}

