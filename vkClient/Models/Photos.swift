//
//  Photos.swift
//  vkClient
//
//  Created by Lina Prosvetova on 01.11.2022.
//

import Foundation


struct PhotosResponse: Codable {
    let response: ResponsePhoto
}

struct ResponsePhoto: Codable {
    let count: Int
    let items: [Photo]
}

struct Photo: Codable {
    var sizes: [Sizes]

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
