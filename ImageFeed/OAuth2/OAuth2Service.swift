import Foundation

fileprivate let AccessTokenURL = "https://unsplash.com/oauth/token"

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let storage: OAuth2TokenStorage
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
        assert(Thread.isMainThread)
        if currentTask != nil {
            if lastCode != code {
                currentTask?.cancel()
            } else {
                completion(.failure(NetworkError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(NetworkError.invalidRequest))
            }
        }
        
        lastCode = code
        
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.dataTask(with: request) { data,response,error in
            DispatchQueue.main.async {
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.urlSessionError(error)))
                    }
                    return
                }
                
                if let response = response as? HTTPURLResponse {
                    if response.statusCode < 200 || response.statusCode >= 300 {
                        DispatchQueue.main.async {
                            completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                        }
                        return
                    }
                }
                
                if let data = data {
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                        DispatchQueue.main.async {
                            //MARK: accessToken
                            print(responseBody.accessToken)
                            completion(.success(responseBody.accessToken))
                        }
                    } catch {
                        assertionFailure("Decode error \(error)")
                    }
                }
                self.currentTask = nil
                self.lastCode = nil
            }
        }
        self.currentTask = task
        task.resume()
    }
}



extension OAuth2Service {
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
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
