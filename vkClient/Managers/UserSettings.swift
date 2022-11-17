//
//  UserDefoltsManager.swift
//  vkClient
//
//  Created by Lina Prosvetova on 15.11.2022.
//

import UIKit

class UserSettings {
    let defaults = UserDefaults.standard
    var entryCount = 1
    let entryCountKey = "entryCount"
    
    init() {
        loadSettings()
    }
    
    func saveSettings() {
        defaults.set(entryCount, forKey: entryCountKey)
    }
    
    func loadSettings() {
        guard defaults.value(forKey: entryCountKey) != nil else { return }
        entryCount = defaults.integer(forKey: entryCountKey )
        
    }
}
