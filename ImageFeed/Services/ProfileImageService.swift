import Foundation
import UIKit
final class ProfileImageService {
    static let shared = ProfileImageService()
    private let storage = OAuth2TokenStorage.shared
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private var currentTask: URLSessionTask?
    private(set) var avatarURL: String?
    private let urlBilder = URLRequestBilder.shared
    
    
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if let currentTask {
            currentTask.cancel()
        }
        
        guard let request = makeRequest(username: username) else { return }
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let json):
                let mediumPhotoURL = json.profileImage.medium
                self.avatarURL = mediumPhotoURL
                completion(.success(mediumPhotoURL))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": mediumPhotoURL])
                
            case .failure(let error):
                completion(.failure(error))
            }
            self.currentTask = nil
        }
        self.currentTask = task
        task.resume()
        
    }
    
    private func makeRequest(username: String) -> URLRequest? {
        urlBilder.makeHTTPRequst(path: "/users/\(username)",
                                 httpMethod: "GET",
                                 baseURLString: Constant.defaultBaseURLString)
       
    }
}
