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
