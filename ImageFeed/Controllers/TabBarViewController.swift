//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 14/10/2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")as? ImagesListViewController else { print ("Не удалось создать ImagesListViewController")
            return }
         
        let imagesListPresenter = ImagesListPresenter()
            imagesListViewController.configurePresenter(imagesListPresenter)
        
        let profileViewController = ProfileViewController()
        profileViewController.configure(ProfilePresenter())
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        self.viewControllers
        = [imagesListViewController, profileViewController]
    }
}
