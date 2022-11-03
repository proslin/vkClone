//
//  Group.swift
//  vkClient
//
//  Created by Lina Prosvetova on 10.10.2022.
//

import Foundation

struct GroupsResponse: Codable {
    let response: ResponseGroup
}

struct ResponseGroup: Codable {
    let count: Int
    let items: [Group]
}

struct Group: Codable, Equatable {
    var groupName: String
    var groupAvatarURL: String
    var membersCount: Int?
    var groupId: Int
    enum CodingKeys: String, CodingKey {
        case groupName = "name"
        case groupAvatarURL = "photo_100"
        case membersCount = "members_count"
        case groupId = "id"
    }
}


