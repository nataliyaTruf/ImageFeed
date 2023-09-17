//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 18/08/2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatarImageView = setupAvatarImageView()
        let nameLabel = setupNameLabel(with: avatarImageView)
        let loginNameLabel = setupLoginNameLabel(with: nameLabel)
        setupDescriptionLabel(with: loginNameLabel)
        setupLogoutButton(with: avatarImageView)
    }
    
    private func setupAvatarImageView() -> UIImageView {
        let avatarImage = UIImage(named: "Avatar")
        let avatarImageView = UIImageView(image: avatarImage)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        avatarImageView.backgroundColor = .clear
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        return avatarImageView
    }
    
    private func setupNameLabel(with avatarImageView: UIImageView) -> UILabel {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16).isActive = true
        
        return nameLabel
    }
    
    private func setupLoginNameLabel(with nameLabel: UILabel) -> UILabel {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .ypWhite
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        
        return loginNameLabel
    }
    
    private func setupDescriptionLabel(with loginNameLabel: UILabel) {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
    
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: loginNameLabel.trailingAnchor).isActive = true
    }
    
    private func setupLogoutButton(with avatarImageView: UIImageView) {
        let logoutButton = UIButton()
        let logoutButtonImage = UIImage(named: "logout_button")
        logoutButton.setImage(logoutButtonImage, for: .normal)
        
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView.trailingAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {
        
    }
}

