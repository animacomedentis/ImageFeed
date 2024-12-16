import Foundation

fileprivate let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"


public protocol WebViewPresenterProtocol {
    var view: WebViewControllerProtocol? {get set}
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL?) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
   
    
    weak var view: WebViewControllerProtocol?
    
    func viewDidLoad() {
        guard var urlComponents = URLComponents(string: UnsplashAuthorizeURLString) else {
            print("Failed to make urlComponents")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constant.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constant.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constant.accessScope)
        ]
        guard let url = urlComponents.url else {
            print("Failed to make URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        didUpdateProgressValue(0)
        
        view?.load(request: request)
    }
    
    func code(from url: URL) -> String? {
        if
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
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}
