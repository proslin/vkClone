//
//  UserDefoltsManager.swift
//  vkClient
//
//  Created by Lina Prosvetova on 15.11.2022.
//

import UIKit
final class UserSettings {
    static var entryCount: Int {
        set { UserDefaults.standard.set(newValue, forKey: VKConstants.entryCountKey) }
        get { return UserDefaults.standard.integer(forKey: VKConstants.entryCountKey) }
    }
}
