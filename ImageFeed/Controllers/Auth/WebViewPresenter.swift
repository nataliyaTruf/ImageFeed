//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Nataliya TRUFANOVA on 06/01/2024.
//

import Foundation

protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func fetchCode(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    func fetchCode(from url: URL) -> String? {
        guard let components = URLComponents(string: url.absoluteString),
              components.path == WebConstants.authorizedPath,
              let codeItem = components.queryItems?.first(where: { $0.name == WebConstants.code})
        else { return nil }
        
        return codeItem.value
    }
    
    
    weak var view: WebViewViewControllerProtocol?
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func viewDidLoad() {
        loadWebView()
        didUpdateProgressValue(0)
    }
}

extension WebViewPresenter {
    private func loadWebView() {
        var urlComponents = URLComponents(string: WebConstants.authorizeURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: WebKeys.clientID, value: Constants.accessKey),
            URLQueryItem(name: WebKeys.redirectURI, value: Constants.redirectURI),
            URLQueryItem(name: WebKeys.responseType, value: WebConstants.code),
            URLQueryItem(name: WebKeys.scope, value: Constants.accessScope)
        ]
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            view?.load(request: request)
        }
    }
    
}
