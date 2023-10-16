//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 25/09/2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let profileServive = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let alertPresenter = AlertPresenter()
    
    private lazy var splashImageView: UIImageView = {
        let splashImage = UIImage(named: "splash_screen_logo")
        let splashImageView = UIImageView(image: splashImage)
        splashImageView.contentMode = .scaleAspectFit
        return splashImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
        setUpSplashImageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard UIBlokingProgressHUD.isShowing == false else { return }
        checkAuthTokenAndFetchProfile()
    }
}

private extension SplashViewController {
    func showLoginAlert(error: Error) {
        alertPresenter.showAlert(title: "Что-то пошло не так :(",
                                 message: "Не удалось войти в систему: \(error.localizedDescription)") { [weak self] in
            self?.presentAuthViewController()
        }
    }
    
    func checkAuthTokenAndFetchProfile() {
        if oauth2Service.isAuthenticated {
            fetchProfile()
        } else {
            presentAuthViewController()
        }
    }
    
    func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

private extension SplashViewController {
    func setUpSplashImageView() {
        view.addSubview(splashImageView)
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.widthAnchor.constraint(equalToConstant: 75),
            splashImageView.heightAnchor.constraint(equalToConstant: 77.68)
        ])
    }
    
    func presentAuthViewController() {
        guard let authViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
        else {
            assertionFailure("Failed to show Authentication Screen")
            return
    }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        self.present(authViewController, animated: true, completion: nil)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlokingProgressHUD.show()
            self.fetchOAuthToken(code)
            self.checkAuthTokenAndFetchProfile()
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.fetchProfile()
            case.failure(let error):
                UIBlokingProgressHUD.dismiss()
                self.showLoginAlert(error: error)
                break
            }
        }
    }
    
    private func fetchProfile() {
        profileServive.fetchProfile() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                UIBlokingProgressHUD.dismiss()
                guard let username = self.profileServive.profile?.username else { return }
                self.profileImageService.fetchProfileImageURL(username: username) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                UIBlokingProgressHUD.dismiss()
                self.showLoginAlert(error: error)
                break
            }
        }
    }
}
