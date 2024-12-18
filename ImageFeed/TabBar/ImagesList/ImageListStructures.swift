import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String?
    let largeImageURL: String?
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let updatedAt: String?
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    let likes: Int?
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "update_at"
        case width
        case height
        case color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description
        case urls = "urls"
    }
}

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
    
    private enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}

struct LikeResult: Codable {
    let photo: PhotoResult?
}
