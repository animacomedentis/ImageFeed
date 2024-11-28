import Foundation

final class URLRequestBilder {
    static let shared = URLRequestBilder()
    
    private let storage: OAuth2TokenStorage
    
    init(storage: OAuth2TokenStorage = .shared) {
        self.storage = storage
    }
        
    func makeHTTPRequst (path: String, httpMethod: String, baseURLString: String) -> URLRequest? {
       
       guard
           let url = URL(string: baseURLString),
           let baseUrl = URL(string: path, relativeTo: url)
       else { return nil }
        
       var request = URLRequest(url: baseUrl)
       request.httpMethod = httpMethod
       
        if let token = storage.token {
           request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
       }
        
       return request
   }

}
