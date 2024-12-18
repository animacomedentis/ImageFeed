import UIKit
@preconcurrency import WebKit



public protocol WebViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? {get set}
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController & WebViewControllerProtocol{
    
    var presenter: WebViewPresenterProtocol?
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progress: UIProgressView!
    weak var delegate: WebViewViewControllerDelegate?
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.accessibilityIdentifier = "UnsplashWebView"
        webView.navigationDelegate = self
        presenter?.viewDidLoad()
        webViewSetup()
    }
    
    
    //MARK: viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    //MARK: viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
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
    
    @objc
    private func didTapBackButtonWebView(){
        delegate?.webViewViewControllerDidCancel(self)
    }
  
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context
            )
        }
    }
    
    func setProgressValue(_ newValue: Float) {
        progress.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progress.isHidden = isHidden
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
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
