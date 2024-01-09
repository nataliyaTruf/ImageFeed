//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 06/01/2024.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func setup()
    func observeProfileImageChanges()
    func performLogautAndSwitchToSplashView()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private var imagesListService = ImagesListService.shared
    private var token = OAuth2TokenStorage.shared
    
    // MARK: - ProfileViewPresenterProtocol methods
    
    func setup() {
        observeProfileImageChanges()
        updateProfileDetails()
        updateAvatar()
    }
    
    func observeProfileImageChanges() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
    }
    
    func performLogautAndSwitchToSplashView() {
        WebViewViewController.clean()
        token.clearTokenData()
        profileService.clearProfileData()
        profileImageService.clearProfileImageData()
        imagesListService.clearImagesListData()
        
        NavigationService.shared.switchToSplashView()
    }
    
    // MARK: - Private methods
    
    private func updateProfileDetails() {
        guard let profile = profileService.profile
        else {
            print("Profile not found. Redirecting to login...")
            return }
        view?.updateProfileDetails(
            name: profile.name,
            loginName: profile.loginName,
            bio: profile.bio
        )
    }
    
    private func updateAvatar() {
        guard
            let profileImageURLString = profileImageService.avatarURL,
            let url = URL(string: profileImageURLString)
        else { return }
        view?.updateAvatar(with: url)
    }
    
    deinit {
        if let observer = profileImageServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
