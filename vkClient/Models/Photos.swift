//
//  Photos.swift
//  vkClient
//
//  Created by Lina Prosvetova on 01.11.2022.
//

import Foundation
import RealmSwift


struct PhotosResponse: Codable {
    let response: ResponsePhoto
}

struct ResponsePhoto: Codable {
    let count: Int
    let items: [Photo]
}

class Photo: Object, Codable {
    ///Id фото
    @objc dynamic var id: Int = 0
    ///Id владельца фото
    @objc dynamic var ownerId: Int = 0
    /// массив фотографий пользователя разных размеров содерж url и type(sizes)
    var sizes: [Sizes] = []
    /// URL фото из sizes размера  "m"
    @objc dynamic var photoURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case ownerId = "owner_id"
        case id = "id"
        case sizes = "sizes"
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override class func ignoredProperties() -> [String] {
        return ["sizes"]
    }
}

struct Sizes: Codable {
    var url: String
    var type: String
}

enum PhotoSize: String {
    case small = "s"
    case medium = "m"
    case large = "l"
}

