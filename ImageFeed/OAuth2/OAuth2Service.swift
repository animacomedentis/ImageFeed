import Foundation

fileprivate let AccessTokenURL = "https://unsplash.com/oauth/token"

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let dataStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError(Error)
    }
    
    func fetchOAuthToken (code: String, completion: @escaping (Result<String, Error>) -> Void){
        
        guard var urlComponents = URLComponents(string: AccessTokenURL) else {
            return assertionFailure("Failed to make urlComponents from \(AccessTokenURL)")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constant.AccessKey),
            URLQueryItem(name: "client_secret", value: Constant.SecretKey),
            URLQueryItem(name: "redirect_uri", value: Constant.RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else{
            return assertionFailure("Failed to make URL from \(urlComponents)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {data,response,error in
            
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
        }
        task.resume()
    }
}
