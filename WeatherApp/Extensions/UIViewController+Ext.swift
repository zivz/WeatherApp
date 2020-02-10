//
//  UIViewController+Ext.swift
//  WeatherApp
//
//  Created by Zalzstein, Ziv on 10/02/2020.
//  Copyright © 2020 Zalzstein, Ziv. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlertOnMain(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
