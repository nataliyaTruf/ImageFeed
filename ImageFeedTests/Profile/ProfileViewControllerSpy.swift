//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Nataliya TRUFANOVA on 08/01/2024.
//

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    
    var updateProfileDetailsCalled = false
    var name: String?
    var loginName: String?
    var bio: String?
    
    var updateAvatarCalled = false
    var lastAvatarUrl: URL?
    
    var showLogoutAlertCalled = false
    
    func updateProfileDetails(name: String, loginName: String, bio: String?) {
        updateProfileDetailsCalled = true
                self.name = name
                self.loginName = loginName
                self.bio = bio
    }
    
    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
        lastAvatarUrl = url
    }
    
    func showLogoutAlert() {
        showLogoutAlertCalled = true
    }
}
