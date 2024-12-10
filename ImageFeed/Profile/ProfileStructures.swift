import Foundation

struct ProfileResult: Codable {
    let userName: String
    let firstName: String
    let lastName: String
    let bio: String?
    let profileImage: ProfileImage
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case profileImage = "profile_image"
    }
}

struct Profile: Codable{
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}
