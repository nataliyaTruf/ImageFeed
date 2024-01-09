//
//  NavigationServiceSpy.swift
//  ImageFeedTests
//
//  Created by Nataliya TRUFANOVA on 09/01/2024.
//

@testable import ImageFeed
import UIKit

final class NavigationServiceSpy: NavigationServiceProtocol {
    var switchToSplashViewCalled = false
    var presentSingleImageCalled = false
    var lastViewController: UIViewController?
    var lastPhoto: Photo?
    
    func switchToSplashView() {
        switchToSplashViewCalled = true
    }
    
    func presentSingleImage(from viewController: UIViewController?, withPhoto photo: Photo) {
        presentSingleImageCalled = true
        lastViewController = viewController
        lastPhoto = photo
    }
}
