//
//  Indicator.swift
//  GeneralPurposeIndicator
//
//  Created by k-aoki on 2021/09/04.
//

// 参考: KRProgressHUD
// 要RxSwift

import UIKit
import RxSwift
import RxCocoa

class Indicator {
    
    // MARK: Singleton
    static let shared = Indicator()
    
    
    // MARK: Variables
    private let disposeBag = DisposeBag()
    
    private let window = UIWindow(frame: UIScreen.main.bounds)
    private let indicatorViewController = IndicatorViewController()
    private let indicatorView = UIActivityIndicatorView(style: .large)
    
    /// Number of times the indicator is called
    private var increment = BehaviorRelay<Int>(value: 0)
    /// Indicator display status
    private var isShowIndicator = false
    
    
    // MARK: Initialize
    init() {
        setupBind()
    }
    
    
    // MARK: Public Functions
    /// start indicator
    func show() {
        DispatchQueue.main.async { [unowned self] in
            self.incrementCount()
        }
    }
    
    /// stop indicator
    func dismiss() {
        DispatchQueue.main.async { [unowned self] in
            self.decrementCount()
        }
    }
}


// MARK: - Setup
private extension Indicator {
    
    func setupBind() {
        
        increment
            .subscribe(onNext: { [unowned self] increment in
                
                print(increment)
                print(isShowIndicator)
                DispatchQueue.main.async {
                    if increment == 0 {
                        self.dismissIndicator()
                        
                    } else if increment == 1 && !self.isShowIndicator {
                        self.showIndicator()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    func setupIndicator() {
        window.windowLevel = .normal
        window.rootViewController = indicatorViewController
        
        indicatorView.color = .white
        indicatorView.center = indicatorViewController.view.center
        
        indicatorViewController.view.translatesAutoresizingMaskIntoConstraints = false
        indicatorViewController.view.backgroundColor = .lightGray
        indicatorViewController.view.alpha = 0.3
        
        indicatorViewController.view.addSubview(indicatorView)
        indicatorViewController.view.bringSubviewToFront(indicatorView)
    }
}


// MARK: - Private Functions
private extension Indicator {
    
    /// start indicator
    func showIndicator() {
        
        setupIndicator()
        
        indicatorViewController.view.alpha = 0
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            window.windowScene = windowScene
        } else {
            assertionFailure("UIWIndowScene not found")
        }
        window.makeKeyAndVisible()
        
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.indicatorViewController.view.alpha = 1
        })
        
        indicatorView.startAnimating()
        
        isShowIndicator = true
    }
    
    /// stop indicator
    func dismissIndicator() {
        
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            self.indicatorViewController.view.alpha = 0
        }, completion: { [unowned self] _ in
            self.window.isHidden = true
            self.indicatorView.stopAnimating()
            
            self.isShowIndicator = false
        })
    }
    
    func incrementCount() {
        var value = increment.value
        value += 1
        increment.accept(value)
    }
    
    func decrementCount() {
        var value = increment.value
        value -= 1
        increment.accept(value)
    }
}
