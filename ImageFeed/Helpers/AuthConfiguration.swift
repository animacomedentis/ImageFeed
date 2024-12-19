import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let baseURL: URL
    let baseURLString: String
    let baseAuthTokenPath: String
    let unsplashAuthorizeURLString: String
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         baseURL: URL,
         baseURLString: String,
         baseAuthTokenPath: String,
         unsplashAuthorizeURLString: String
    ) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.baseURL = baseURL
        self.baseURLString = baseURLString
        self.baseAuthTokenPath = baseAuthTokenPath
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
    }
    
    static var standard: AuthConfiguration{
        .init(
            accessKey: Constant.accessKey,
            secretKey: Constant.secretKey,
            redirectURI: Constant.redirectURI,
            accessScope: Constant.accessScope,
            baseURL: Constant.baseURL,
            baseURLString: Constant.baseURLString,
            baseAuthTokenPath: Constant.baseAuthTokenPath,
            unsplashAuthorizeURLString: Constant.unsplashAuthorizeURLString
        )
    }
}
