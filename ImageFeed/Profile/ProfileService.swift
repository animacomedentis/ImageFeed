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
        
        currentTask = fetch(request: request) { [weak self] response in
            
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

    func fetch(request: URLRequest, complition: @escaping
    (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
        let fulfillComplitionOnMainThread: (Result<ProfileResult, Error>) -> Void = {
            result in
            DispatchQueue.main.async {
                complition(result)
            }
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(ProfileResult.self, from: data)
                        fulfillComplitionOnMainThread(.success(result))
                    } catch {
                        fulfillComplitionOnMainThread(.failure(NetworkError.decodingError(error)))
                    }
                } else {
                    fulfillComplitionOnMainThread(.failure(NetworkError.invalidRequest))
                }
            } else if let error = error {
                fulfillComplitionOnMainThread(.failure(NetworkError.decodingError(error)))
            } else {
                fulfillComplitionOnMainThread(.failure(NetworkError.invalidRequest))
            }
        })
        task.resume()
        return task
    }
}
