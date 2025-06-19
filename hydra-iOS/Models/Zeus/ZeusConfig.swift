//
//  ZeusConfig.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 29/12/2024.
//

import Foundation

typealias ZeusKeys = GlobalConstants.StorageKeys.Zeus

struct ZeusConfig {
    @MainActor static var sharedInstance = ZeusConfig()
    
    private init() {
        if let plistURL = Bundle.main.url(forResource: "APIKeys", withExtension: "plist") {
            do {
                let plistData = try Data(contentsOf: plistURL)
                let keys = try PropertyListDecoder().decode(APIKeysPreferences.self, from: plistData)
                if let username = keys.ZEUS_USERNAME {
                    self.username = username
                }
                if let doorToken = keys.MM_KEY {
                    self.doorToken = doorToken
                }
                if let tabToken = keys.TAB_KEY {
                    self.tabToken = tabToken
                }
                if let tapToken = keys.TAP_KEY {
                    self.tapToken = tapToken
                }
            } catch {
                print("Failed to load API Keys, this is not critical")
                print(error.localizedDescription)
            }
        }
    }
    
    var username = UserDefaults.standard.string(
        forKey: ZeusKeys.username)
    {
        didSet {
            UserDefaults.standard.set(username, forKey: ZeusKeys.username)
        }
    }
    var doorToken = UserDefaults.standard.string(
        forKey: ZeusKeys.door)
    {
        didSet {
            UserDefaults.standard.set(doorToken, forKey: ZeusKeys.door)
        }
    }
    var tabToken = UserDefaults.standard.string(
        forKey: ZeusKeys.tab)
    {
        didSet {
            UserDefaults.standard.set(tabToken, forKey: ZeusKeys.tab)
        }
    }
    var tapToken = UserDefaults.standard.string(
        forKey: ZeusKeys.tap)
    {
        didSet {
            UserDefaults.standard.set(tapToken, forKey: ZeusKeys.tap)
        }
    }
}
