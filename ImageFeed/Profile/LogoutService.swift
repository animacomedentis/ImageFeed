import Foundation
import WebKit


final class LogoutService {
    static let shared = LogoutService()
    
    private init() { }
    
    func logout(){
        cleanCookies()
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
    
    private func cleanProfile(){
        ProfileService.shared.cleanSession()
        ProfileImageService.shared.cleanSession()
        ImagesListService.shared.cleanSession()
        OAuth2TokenStorage().cleanSession()
    }
}
    

