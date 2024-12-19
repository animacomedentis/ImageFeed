import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    private let tokenKey = "OAuthToken"
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: tokenKey)
        }
        set {
            if let newValue {
                setSuccess(newValue: newValue)
            } else {
                setRemoved()
            }
        }
    }
    
    private func setSuccess(newValue: String){
        let isSuccess = KeychainWrapper.standard.set(newValue, forKey: tokenKey)
        guard isSuccess else {
            print("[OAuth2TokenStorage]: Error saving token to Keychain")
            return
        }
    }
    private func setRemoved() {
        let isRemoved: Bool = KeychainWrapper.standard.removeObject(forKey: tokenKey)
        guard isRemoved else {
            print("[OAuth2TokenStorage]: Error removing token from Keychain")
            return
        }
    }
}
