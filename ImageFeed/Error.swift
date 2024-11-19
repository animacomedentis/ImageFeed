import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError(Error)
    case invalidRequest
    case decodingError(Error)
}