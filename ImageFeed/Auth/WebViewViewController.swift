import UIKit
import WebKit

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController{
    
    weak var delegate: WebViewViewControllerDelegate?

    
    override func viewDidLoad() {
        showWebView()
        
    }
    private func showWebView(){
        
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: view.frame, configuration: config)
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        
        webView.load(request)
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        let backButtonImage = UIImage(named: "nav_back_button")
        let backButton = UIButton.systemButton(with: backButtonImage!, target: self, action: #selector(didTapBackButtonWebView))
        backButton.tintColor = .ypBlack
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 42 ),
            backButton.widthAnchor.constraint(equalToConstant: 130 )
        ])
        
    }
    
    @objc
    private func didTapBackButtonWebView(){
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction){
                //TODO: process code
                decisionHandler(.cancel)
            }else {
                decisionHandler(.allow)
            }
    }
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
