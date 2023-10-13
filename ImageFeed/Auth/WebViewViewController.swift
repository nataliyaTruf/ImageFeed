//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Nataliya MASSOL on 18/09/2023.
//

import UIKit
import WebKit


protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    private enum WebKeys {
        static let clientID: String = "client_id"
        static let redirectURI: String = "redirect_uri"
        static let responseType: String = "response_type"
        static let scope: String = "scope"
    }
    
    private enum WebConstants {
        static let authorizeURL: String = "https://unsplash.com/oauth/authorize"
        static let code: String = "code"
        static let authorizedPath: String = "/oauth/authorize/native"
    }
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    @IBOutlet var webView: WKWebView!
    @IBOutlet var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        loadWebView()
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
            changeHandler: { [weak self] _, _ in
                guard let self = self else { return }
                self.updateProgress()
            })
        updateProgress()
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ){
        if let code = fetchCode(url: navigationAction.request.url) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}

private extension WebViewViewController {
    func loadWebView() {
        var urlComponents = URLComponents(string: WebConstants.authorizeURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: WebKeys.clientID, value: Constants.accessKey),
            URLQueryItem(name: WebKeys.redirectURI, value: Constants.redirectURI),
            URLQueryItem(name: WebKeys.responseType, value: WebConstants.code),
            URLQueryItem(name: WebKeys.scope, value: Constants.accessScope)
        ]
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func fetchCode(url: URL?) -> String? {
        guard let url = url,
              let components = URLComponents(string: url.absoluteString),
              components.path == WebConstants.authorizedPath,
              let codeItem = components.queryItems?.first(where: { $0.name == WebConstants.code})
        else { return nil }
        
        return codeItem.value
    }
}
