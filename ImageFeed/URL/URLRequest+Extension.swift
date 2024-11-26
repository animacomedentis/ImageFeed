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
       
       var requst = URLRequest(url: baseUrl)
       requst.httpMethod = httpMethod
       
       
        if let token = storage.token {
           requst.setValue("Bearer \(token)", forHTTPHeaderField: "Autorization")
       }
       return requst
   }

}
