//
//  Session.swift
//  vkClient
//
//  Created by Lina Prosvetova on 31.10.2022.
//

import Foundation

class Session {
    static let shared = Session()
    
    private init() {}
    var token: String = ""
    var userId: Int = 0
}
