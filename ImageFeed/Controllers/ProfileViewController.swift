//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 18/08/2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateProfileDetails(name: String, loginName: String, bio: String?)
    func updateAvatar(with url: URL)
    func showLogoutAlert()
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var alertPresenter = AlertPresenter()
    
    // MARK: - UI Elements
    
    lazy var avatarImageView: UIImageView = {
        let avatarImage = UIImage(named: "Avatar")
        let avatarImageView = UIImageView(image: avatarImage)
        avatarImageView.backgroundColor = .clear
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.clipsToBounds = true
        return avatarImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.accessibilityIdentifier = "nameLabel"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return nameLabel
    }()
    
    lazy var loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.accessibilityIdentifier = "loginNameLabel"
        loginNameLabel.textColor = .ypWhite
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return loginNameLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton()
        let logoutButtonImage = UIImage(named: "logout_button")
        logoutButton.setImage(logoutButtonImage, for: .normal)
        logoutButton.accessibilityIdentifier = "logout_button"
        logoutButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return logoutButton
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypBlack
        addSubviews()
        makeConstraints()
        
        presenter?.viewDidLoad()
        alertPresenter.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(loginNameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(logoutButton)
    }
    
    private func makeConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: loginNameLabel.trailingAnchor),
            
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.leadingAnchor.constraint(greaterThanOrEqualTo: avatarImageView.trailingAnchor)
        ])
    }
    
    @objc func didTapButton() {
        showLogoutAlert()
    }
}

extension ProfileViewController {
    func updateProfileDetails(name: String, loginName: String, bio: String?) {
        nameLabel.text = name
        loginNameLabel.text = loginName
        descriptionLabel.text = bio
    }
    
    func updateAvatar(with url: URL) {
        let processor = RoundCornerImageProcessor(cornerRadius: 70, backgroundColor: .clear)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "avatar_placeholder"),
            options: [.processor(processor)]
        )
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
}

extension ProfileViewController {
    func showLogoutAlert() {
        alertPresenter.showLogoutAlert() { [weak self] in
            self?.presenter?.performLogautAndSwitchToSplashView()
        }
    }
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
}
