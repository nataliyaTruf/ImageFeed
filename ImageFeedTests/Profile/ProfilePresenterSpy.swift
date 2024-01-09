//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Nataliya MASSOL on 08/01/2024.
//

@testable import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    weak var view: ImageFeed.ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var observeProfileImageChangesCalled = false
    var performLogoutCalled = false
    var showLogoutAlertCalled = false
    
    func setup() {
        viewDidLoadCalled = true
    }
    
    func observeProfileImageChanges() {
        observeProfileImageChangesCalled = true
    }
    
    func performLogautAndSwitchToSplashView() {
        performLogoutCalled = true
    }
    
    func showLogoutAlert() {
        print("showLogoutAlert called in ProfilePresenterSpy")
        showLogoutAlertCalled = true
    }
}
