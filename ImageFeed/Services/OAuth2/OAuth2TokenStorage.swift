import Foundation
import UIKit
import SwiftKeychainWrapper

struct OAuth2TokenStorage {
    static var shared = OAuth2TokenStorage()
    
    private enum Keys: String{
        case token
    }
    
     var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let token = newValue else { return }
            
            let isSuccess = KeychainWrapper.standard.set(token, forKey: Keys.token.rawValue)
            guard isSuccess else { fatalError() }
        }
    }
}
