//
//  NavigationService.swift
//  ImageFeed
//
//  Created by Nataliya TRUFANOVA on 07/01/2024.
//

import UIKit

class NavigationService {
    let splashViewController = SplashViewController()
    static let shared = NavigationService()
    
    func switchToSplashView() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            window.rootViewController = self.splashViewController
        }
    }
}
