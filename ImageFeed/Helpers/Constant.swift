import Foundation

enum Constant {
    static let accessKey = "p9-i6_1ElVfnbrrRXb5mjjJmQsY3uTsj68Nt_X2PIiY"
    static let secretKey = "HT4G1MjJsHzmVKLVP30tLnZe_R1qIpgIs-ut87twQvo"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let baseURL = URL(string: baseURLString)!
    static let baseURLString = "https://api.unsplash.com"
    static let baseAuthTokenPath =  "https://unsplash.com/oauth/token"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
