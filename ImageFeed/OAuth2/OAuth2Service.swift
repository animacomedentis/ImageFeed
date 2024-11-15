import Foundation

fileprivate let AccessTokenURL = "https://unsplash.com/oauth/token"

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    private let dataStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchOAuthToken (code: String, completion: @escaping (Result<String, Error>) -> Void){
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
            }
        }
        
        lastCode = code
        
        guard
            let request = makeOAuthTokenRequest(code: code)
        else {
            completion(.failure(AuthServiceError.invalidRequest))
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
                self.task = nil
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError(Error)
    }
}

extension OAuth2Service {
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        let baseURL = URL(string: "https://unsplash.com")
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constant.accessKey)"
            + "&&client_secret=\(Constant.secretKey)"
            + "&&redirect_uri=\(Constant.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
