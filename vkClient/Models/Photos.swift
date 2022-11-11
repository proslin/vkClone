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
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    
    var sizes: [Sizes]
    @objc dynamic var photoURL: String {
        return sizes.first(where: { $0.type == "m" })?.url ?? ""
    }
    enum CodingKeys: String, CodingKey {
        case ownerId = "owner_id"
        case id = "id"
        case sizes = "sizes"
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

class PhotoObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerId: Int = 0
    @objc dynamic var photoURL: String = ""
    //@objc dynamic var owner: Friend?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
   convenience init(photoId: Int, photoURL: String, owner: Int) {
       self.init()
       self.id = photoId
       self.photoURL = photoURL
       self.ownerId = owner
    }
}

