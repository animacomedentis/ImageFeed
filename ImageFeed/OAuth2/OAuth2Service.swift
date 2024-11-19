import Foundation

fileprivate let AccessTokenURL = "https://unsplash.com/oauth/token"

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private var storage: OAuth2TokenStorage
    private let builder: URLRequestBilder
    private let urlSession: URLSession
    private var currentTask: URLSessionTask?
    private var lastCode: String?
    
    init(
        builder: URLRequestBilder = .shared,
        urlSession: URLSession = .shared,
        storage: OAuth2TokenStorage = .shared
    ) {
        self.builder = builder
        self.urlSession = urlSession
        self.storage = storage
    }
    
    func fetchOAuthToken (code: String, completion: @escaping (Result<String, Error>) -> Void){
        guard code != lastCode, currentTask != nil else { return }
        
        lastCode = code
        
        guard
            let request = authTokenRequest(code: code)
        else {
            assertionFailure("Invalid Request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        currentTask = session.objectTask(for: request) { [weak self] (response: Result<OAuthTokenResponseBody, Error>) in
            
            self?.currentTask = nil
            
            switch response {
            case .success(let body):
                let authToken = body.accessToken
                self?.storage.token = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
}

extension OAuth2Service {
    
    private func authTokenRequest(code: String) -> URLRequest? {
        builder.makeHTTPRequst(
            path: "\(Constant.baseAuthTokenPath)"
            + "?client_id=\(Constant.accessKey)"
            + "&&client_secret=\(Constant.secretKey)"
            + "&&redirect_uri=\(Constant.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURLString: Constant.defaultBaseURLString
        )
    }
}
