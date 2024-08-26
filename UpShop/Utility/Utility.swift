//
//  Utility.swift
//  UpShop
//
//  Created by Admin on 23/05/22.
//

import Foundation
import UIKit

let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)

func getViewWithTag(tag:NSInteger, view: UIView) -> UIView {
    return view.viewWithTag(tag)!
}

func showAlert(message:String, controller:UIViewController) {
    
    let alert = UIAlertController(title: NSLocalizedString("Alert", comment: ""), message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
        switch action.style{
        case .default:
            print("default")
        case .cancel:
            print("cancel")
        case .destructive:
            print("destructive")
        @unknown default:
            print("default")
        }}))
    
    controller.present(alert, animated: true, completion: nil)
    
}
