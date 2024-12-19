import Foundation

struct UserResult: Decodable {
    let profileImageMediumURL: URL
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    enum ProfileImageKeys: String, CodingKey {
        case medium
    }
    
    init(from decoder: Decoder) throws {
        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let profileImageContainer = try container.nestedContainer(keyedBy: ProfileImageKeys.self,
                                                                      forKey: .profileImage)
            profileImageMediumURL = try profileImageContainer.decode(URL.self, forKey: .medium)
        } catch {
            print("Error while decoding UserResult: \(error.localizedDescription)")
            throw error
        }
    }
    
}
