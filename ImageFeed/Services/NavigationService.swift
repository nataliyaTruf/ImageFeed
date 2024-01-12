//
//  NavigationService.swift
//  ImageFeed
//
//  Created by Nataliya TRUFANOVA on 07/01/2024.
//

import UIKit

protocol NavigationServiceProtocol {
    func switchToSplashView()
    func presentSingleImage(from viewController: UIViewController?, withPhoto photo: Photo)
}

final class NavigationService: NavigationServiceProtocol {
    static var shared: NavigationServiceProtocol = NavigationService()
    private let splashViewController = SplashViewController()
    
    private init() {}
    
    func switchToSplashView() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
            window.rootViewController = self.splashViewController
        }
    }
    
    func presentSingleImage(from viewController: UIViewController?, withPhoto photo: Photo) {
        guard let viewController = viewController else {
            print("NavigationService Error: viewController is nil")
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let singleImageVC = storyboard.instantiateViewController(withIdentifier: "SingleImageViewController") as? SingleImageViewController {
            singleImageVC.fullImageURL = URL(string: photo.largeImageURL)
            singleImageVC.modalPresentationStyle = .fullScreen
            
            viewController.present(singleImageVC, animated: true)
        } else {
            print("NavigationService Error: не получилось установить SingleImageViewController")
        }
    }
}
