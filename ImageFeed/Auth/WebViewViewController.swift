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
    private struct WebKeys {
        static let clientID = "client_id"
        static let redirectURI = "redirect_uri"
        static let responseType = "response_type"
        static let scope = "scope"
    }
    
    private struct WebConstants {
        static let authorizeURL = "https://unsplash.com/oauth/authorize"
        static let code = "code"
        static let authorizedPath = "/oauth/autorize/native"
    }
    
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
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        updateProgress()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
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
        if let code = fetchCode(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func fetchCode(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == WebConstants.authorizedPath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == WebConstants.code})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

private extension WebViewViewController {
    func loadWebView () {
        var urlComponents = URLComponents(string: WebConstants.authorizeURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: WebKeys.clientID, value: AccessKey),
            URLQueryItem(name: WebKeys.redirectURI, value: RedirectURI),
            URLQueryItem(name: WebKeys.responseType, value: WebConstants.code),
            URLQueryItem(name: WebKeys.scope, value: AccessScope)
        ]
        if let url = urlComponents?.url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
