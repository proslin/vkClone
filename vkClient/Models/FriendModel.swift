//
//  Friend.swift
//  vkClient
//
//  Created by Lina Prosvetova on 10.10.2022.
//

import Foundation
import RealmSwift

struct FriendsResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let count: Int
    let items: [FriendModel]
}

final class FriendModel: Object, Codable {
    ///имя друга
    @objc dynamic var firstName: String = ""
    ///фамилия друга
    @objc dynamic var lastName: String = ""
    ///Id друга
    @objc dynamic var friendId: Int = 0
    ///URL аватара
    @objc dynamic var friendAvatarURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case friendId = "id"
        case friendAvatarURL = "photo_100"
    }
    
    override static func primaryKey() -> String? {
        return "friendId"
    }

}
