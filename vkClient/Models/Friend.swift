//
//  Friend.swift
//  vkClient
//
//  Created by Lina Prosvetova on 10.10.2022.
//

import Foundation

struct FriendsResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let count: Int
    let items: [Friend]
}

struct Friend: Codable {
    var firstName: String
    var lastName: String
    var friendId: Int
    var friendAvatarURL: String
    //var friendPhotoAlbum: [String]
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case friendId = "id"
        case friendAvatarURL = "photo_100"
    }
}
