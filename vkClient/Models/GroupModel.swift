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

struct GroupDeleteAddResponse: Codable {
    let response: Int
}

struct ResponseGroup: Codable {
    let count: Int
    let items: [GroupModel]
}

final class GroupModel: Object, Codable {
    ///название группы
    @objc dynamic var groupName: String = ""
    ///URL аватара
    @objc dynamic var groupAvatarURL: String = ""
    ///Id группы
    @objc dynamic var groupId: Int = 0
    ///количество участников
    var membersCount: Int?
    
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



