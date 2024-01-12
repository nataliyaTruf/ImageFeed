//
//  MockAlertPresenter.swift
//  ImageFeedTests
//
//  Created by Nataliya TRUFANOVA on 09/01/2024.
//

@testable import ImageFeed
import Foundation

final class AlertPresenterMock: AlertPresenter {
    var showAlertCalled = false
    var showRetryAlertCalled = false
    var showLogoutAlertCalled = false
    
    override func showAlert(
        title: String,
        message: String,
        handler: @escaping () -> Void) {
            showAlertCalled = true
            handler()
        }
    
    override func showRetryAllert(title: String,
                                  message: String,
                                  retryHandler: @escaping () -> Void
    ) {
        showRetryAlertCalled = true
        retryHandler()
    }
    
    override func showLogoutAlert(logoutHandler: @escaping () -> Void) {
        showLogoutAlertCalled = true
        logoutHandler()
    }
}
