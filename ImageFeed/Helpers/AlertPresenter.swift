//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Created by Nataliya TRUFANOVA on 13/10/2023.
//

import UIKit

final class AlertPresenter {
    weak var delegate: UIViewController?
    
    func showAlert(
        title: String,
        message: String,
        handler: @escaping () -> Void) {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                handler()
            }
            alert.addAction(okAction)
            delegate?.present(alert, animated: true)
        }
    
    func showRetryAllert(
        title: String,
        message: String,
        retryHandler: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Не надо", style: .cancel)
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { _ in
            retryHandler()
        }
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    func showLogoutAlert(logoutHandler: @escaping () -> Void) {
        let alert = UIAlertController(
        title: "Пока, пока!",
        message: "Вы уверены, что хотите выйти?",
        preferredStyle: .alert
        )
        
        let logautAction = UIAlertAction(title: "Да",
                                         style: .destructive) { _ in logoutHandler() }
        let cancelAction = UIAlertAction(title: "Нет",
                                         style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(logautAction)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
