import Foundation

extension URLSession {
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionDataTask {
        
        let fulfillComplitionOnMainThread: (Result<T, Error>) -> Void = {
            result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(T.self, from: data)
                        fulfillComplitionOnMainThread(.success(result))
                    } catch {
                        fulfillComplitionOnMainThread(.failure(NetworkError.decodingError))
                    }
                } else {
                    fulfillComplitionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillComplitionOnMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillComplitionOnMainThread(.failure(NetworkError.invalidRequest))
            }
        })
        task.resume()
        return task
    }
}

