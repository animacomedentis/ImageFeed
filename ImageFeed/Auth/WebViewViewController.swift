import UIKit
@preconcurrency import WebKit

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController{
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progress: UIProgressView!
    weak var delegate: WebViewViewControllerDelegate?
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webViewSetup()
        makeRequest()
        
    }
    
    //MARK: viewsetup
    private func webViewSetup() {
        webView.frame = view.frame
        
        //MARK: backButton
        let backButtonImage = UIImage(named: "nav_back_button")
        let backButton = UIButton.systemButton(with: backButtonImage!, target: self, action: #selector(didTapBackButtonWebView))
        backButton.tintColor = .ypBlack
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        //MARK: progress
        progress.progressTintColor = .ypBlack
        progress.progress = 0.0
        progress.isHidden = true
        progress.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: constraint
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 42 ),
            backButton.widthAnchor.constraint(equalToConstant: 130 ),
            progress.topAnchor.constraint(equalTo: backButton.bottomAnchor),
            progress.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progress.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    //MARK: Request
    private func makeRequest() {
        guard var urlComponents = URLComponents(string: UnsplashAuthorizeURLString) else {
            fatalError("Failed to make urlComponents")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constant.AccessKey),
            URLQueryItem(name: "redirect_uri", value: Constant.RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constant.AccessScope)
        ]
        if let url = urlComponents.url{
            let request = URLRequest(url: url)
            webView.load(request)
        }else {
            fatalError("Failed to make URL")
        }
    }
    
    @objc
    private func didTapBackButtonWebView(){
        delegate?.webViewViewControllerDidCancel(self)
    }
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        updateProgress()
    }
    
    //MARK: viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progress.progress = Float(webView.estimatedProgress)
        progress.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction){
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
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
