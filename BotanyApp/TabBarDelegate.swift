//
//  TabBarDelegate.swift
//  BotanyApp
//
//  Created by Saidac Alexandru on 19.09.2022.
//

import Foundation
import UIKit

class TabBarDelegate: NSObject, UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
       let navigationController = viewController as? UINavigationController
        navigationController?.popViewController(animated: true )
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let selectedViewController = tabBarController.selectedViewController
        guard let _ = selectedViewController else{
            return false
        }
        if selectedViewController == viewController{
            return false
        }
        guard let controllerIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else{
            return false
        }
        if controllerIndex == 1{
            let postStoryBoard = UIStoryboard(name: "Post", bundle: nil)
            let postVC = postStoryBoard.instantiateViewController(withIdentifier: "AddPlanViewController")
            selectedViewController?.present(postVC, animated: true)
            return false
        }
        return true
    }
        
    
}
