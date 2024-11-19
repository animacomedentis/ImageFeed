import Foundation


final class ProfileService {
    static let shared = ProfileService()
    
    private let builder: URLRequestBilder
    private(set) var profile: Profile?
    private var currentTask: URLSessionTask?
    
    init(builder: URLRequestBilder = .shared) {
        self.builder = builder
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        currentTask?.cancel()
        
        guard
            let request = makeFetchProfileRequest(token: token)
        else {
            assertionFailure("Invalid Request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        currentTask = session.objectTask(for: request) { [weak self] (response: Result<ProfileResult, Error>) in
            
            self?.currentTask = nil
            
            switch response {
            case .success(let profileResult):
                let profile = Profile(result: profileResult)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension ProfileService {
    func makeFetchProfileRequest (token: String) -> URLRequest? {
        builder.makeHTTPRequst(path: "/me",
                               httpMethod: "GET",
                               baseURLString: Constant.defaultBaseURLString
        )
    }
}
