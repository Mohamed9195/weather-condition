//
//  Alery.swift
//  Climat
//
//  Created by mohamed hashem on 9/2/19.
//  Copyright © 2019 mohamed hashem. All rights reserved.
//

import UIKit

class Alert {
    
    let alert: UIAlertController
    
    init(title: String? = nil, message: String? = nil) {
        alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    }
    
    func add(action: UIAlertAction) -> Self {
        alert.addAction(action)
        return self
    }
    
    func addCancelAction(title: String = NSLocalizedString("Cancel", comment: "")) -> Self {
        alert.addAction(UIAlertAction(title: title, style: .cancel, handler: nil))
        return self
    }
    
    func show(in vc: UIViewController? = nil) {
        let vc = vc ?? UIApplication.shared.keyWindow!.rootViewController!
        
        vc.present(alert, animated: true, completion: nil)
    }
}
