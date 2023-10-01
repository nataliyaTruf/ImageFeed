//
//  UIBlokingProgressHUD.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 01/10/2023.
//

import UIKit
import ProgressHUD

final class UIBlokingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
