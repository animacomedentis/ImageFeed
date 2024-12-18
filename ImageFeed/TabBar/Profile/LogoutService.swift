import Foundation
import WebKit


final class LogoutService {
    static let shared = LogoutService()
    
    private init() { }
    
    func logout(){
        cleanCookies()
        cleanToken()
        cleanProfile()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                
            }
        }
    }
    
    private func cleanToken() {
        if let token = OAuth2TokenStorage.shared.token {
            print("[OAuth2TokenStorage]: Token found: \(token)")
            OAuth2TokenStorage.shared.token = nil
        } else {
            print("[OAuth2TokenStorage]: No token found to remove")
        }
    }
    
    private func cleanProfile() {
        let profileViewController = ProfileViewController()
        profileViewController.cleanProfileData()
    }
}
    

