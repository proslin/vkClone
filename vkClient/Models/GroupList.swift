//
//  GroupList.swift
//  vkClient
//
//  Created by Lina Prosvetova on 03.11.2022.
//

import Foundation

//struct GroupsResponse: Codable {
//    let response: ResponseGroup
//}
//
//struct ResponseGroup: Codable {
//    let count: Int
//    let items: [Group]
//}
//
//struct Group: Codable,Equatable {
//    var groupName: String
//    var groupAvatarURL: String
//    //var memberCount: Int
//    enum CodingKeys: String, CodingKey {
//        case groupName = "name"
//        case groupAvatarURL = "photo_100"
//    }
//}
struct GroupsListResponse: Codable {
    let response: [Group]
}
