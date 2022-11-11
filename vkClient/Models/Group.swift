//
//  Group.swift
//  vkClient
//
//  Created by Lina Prosvetova on 10.10.2022.
//

import Foundation
import RealmSwift

struct GroupsResponse: Codable {
    let response: ResponseGroup
}

struct ResponseGroup: Codable {
    let count: Int
    let items: [Group]
}

class Group: Object, Codable {
    @objc dynamic var groupName: String = ""
    @objc dynamic var groupAvatarURL: String = ""
    var membersCount: Int?
    @objc dynamic var groupId: Int = 0
    enum CodingKeys: String, CodingKey {
        case groupName = "name"
        case groupAvatarURL = "photo_100"
        case membersCount = "members_count"
        case groupId = "id"
    }
    
    override static func primaryKey() -> String? {
        return "groupId"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["membersCount"]
    }
}



