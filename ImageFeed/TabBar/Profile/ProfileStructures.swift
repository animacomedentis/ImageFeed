struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio: String
    
    init(from profileResult: ProfileResultResponseBody) {
        self.userName = profileResult.userName
        self.name = "\(profileResult.firstName) \(profileResult.lastName)"
        self.loginName = "@\(profileResult.userName)"
        self.bio = profileResult.bio ?? "No bio available"
    }
}
