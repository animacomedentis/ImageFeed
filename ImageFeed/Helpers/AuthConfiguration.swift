import Foundation

enum Constant {
    static let accessKey = "p9-i6_1ElVfnbrrRXb5mjjJmQsY3uTsj68Nt_X2PIiY"
    static let secretKey = "HT4G1MjJsHzmVKLVP30tLnZe_R1qIpgIs-ut87twQvo"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let baseURL = URL(string: baseURLString)!
    static let baseURLString = "https://api.unsplash.com"
    static let baseAuthTokenPath =  "https://unsplash.com/oauth/token"
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let baseURL: URL
    let baseURLString: String
    let baseAuthTokenPath: String
    let UnsplashAuthorizeURLString: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         baseURL: URL,
         baseURLString: String,
         baseAuthTokenPath: String,
         UnsplashAuthorizeURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.baseURL = baseURL
        self.baseURLString = baseURLString
        self.baseAuthTokenPath = baseAuthTokenPath
        self.UnsplashAuthorizeURLString = UnsplashAuthorizeURLString
    }
    
    static var standard: AuthConfiguration{
        return AuthConfiguration(accessKey: Constant.accessKey,
                                 secretKey: Constant.secretKey,
                                 redirectURI: Constant.redirectURI,
                                 accessScope: Constant.accessScope,
                                 baseURL: Constant.baseURL,
                                 baseURLString: Constant.baseURLString,
                                 baseAuthTokenPath: Constant.baseAuthTokenPath,
                                 UnsplashAuthorizeURLString: Constant.UnsplashAuthorizeURLString
        )
    }
}
