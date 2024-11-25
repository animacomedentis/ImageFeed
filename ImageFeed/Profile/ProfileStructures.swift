import Foundation

struct ProfileResult: Codable {
    let userLogin: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
    
    private enum CodingKeys: String, CodingKey {
        case userLogin = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case profileImage = "profile_image"
    }
 
//    init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.userLogin = try container.decode(String.self, forKey: .userLogin)
//        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
//        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
//        self.bio = try container.decodeIfPresent(String.self, forKey: .bio)
//        self.profileImage = try container.decodeIfPresent(ProfileImage.self, forKey: .profileImage)
//    }
}

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct Profile{
    let username: String
    let name: String
    let loginName: String
    let bio: String?
}

extension Profile {
    init(result profile: ProfileResult){
        self.init(
            username: profile.userLogin,
            name: "\(profile.firstName ?? "") \(profile.lastName ?? "")",
            loginName: "@\(profile.userLogin)",
            bio: profile.bio
        )
    }
}
