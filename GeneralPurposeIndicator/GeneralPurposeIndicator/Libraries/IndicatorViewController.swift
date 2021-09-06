//
//  IndicatorViewController.swift
//  GeneralPurposeIndicator
//
//  Created by k-aoki on 2021/09/04.
//

import UIKit

class IndicatorViewController: UIViewController {
    
    // MARK: Variables
    var statusBarStyle = UIStatusBarStyle.default
    var statusBarHidden = false

    
    // MARK: Override
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topVC = getTopViewContorller() else { return statusBarStyle }
        
        if !topVC.isKind(of: IndicatorViewController.self) {
            statusBarStyle = topVC.preferredStatusBarStyle
        }
        
        return statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        guard let topVC = getTopViewContorller() else { return statusBarHidden }
        
        if !topVC.isKind(of: IndicatorViewController.self) {
            statusBarHidden = topVC.prefersStatusBarHidden
        }
        
        return statusBarHidden
    }
}


// MARK: Private Extension
private extension IndicatorViewController {
    
    func getTopViewContorller(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        
        if let navigationController = controller as? UINavigationController {
            return getTopViewContorller(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return getTopViewContorller(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return getTopViewContorller(controller: presented)
        }
        
        return controller
    }
}
