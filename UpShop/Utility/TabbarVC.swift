//
//  TabbarVC.swift
//  UpShop
//
//  Created by Admin on 27/06/22.
//

import Foundation
import UIKit

class TabBarVC: UITabBarController {
 
    override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       let tabWidth = (tabBar.frame.width/CGFloat(tabBar.items!.count))
       let tabHeight = tabBar.frame.height
        self.tabBar.selectionIndicatorImage = UIImage().makeImageWithColorAndSize(color: UIColor(red: 247/255, green: 158/255, blue: 2/255, alpha: 1.0), size: CGSize(width: tabWidth, height: tabHeight)).resizableImage(withCapInsets: UIEdgeInsets.zero)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // UITabBar.appearance().backgroundColor = UIColor(red: 237/255, green: 38/255, blue: 43/255, alpha: 1.0)
        //UITabBar.appearance().tintColor = UIColor(red: 237/255, green: 38/255, blue: 43/255, alpha: 1.0)
        //self.tabBar.app
        // Do any additional setup after loading the view.
        //self.tabBar.tintColor = UIColor.white
        //self.tabBar.barTintColor = UIColor(red: 237/255, green: 38/255, blue: 43/255, alpha: 1.0)
        //self.tabBar.unselectedItemTintColor = UIColor(red: 103/255, green: 7/255, blue: 48/255, alpha: 1.0)
        
        self.tabBar.tintColor = .white
        self.tabBar.backgroundColor = .white
        
        self.tabBar.barTintColor = UIColor.white
        self.tabBar.unselectedItemTintColor =  UIColor.init(red: 119/255, green: 131/255, blue: 143/255, alpha: 1.0)
        
        self.tabBar.isTranslucent = false
        
        self.selectedIndex = 0
        
    }
   
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let vc = self.viewControllers![item.tag] as! UINavigationController
        vc.popToRootViewController(animated: false)
    }
}
