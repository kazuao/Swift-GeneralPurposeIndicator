//
//  ViewController.swift
//  GeneralPurposeIndicator
//
//  Created by k-aoki on 2021/09/04.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func didTapShowIndicatorButton(_ sender: Any) {
        
        Indicator.shared.show()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            Indicator.shared.dismiss()
        }
    }
}

