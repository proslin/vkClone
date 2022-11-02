//
//  NetworkManager.swift
//  vkClient
//
//  Created by Lina Prosvetova on 31.10.2022.
//

import UIKit

struct NetworkManager {
    static let shared   = NetworkManager()
    private let baseUrl = "https://api.vk.com/method"
    let token           = Session.shared.token
    let cache           = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getFriends(completed: @escaping (Result<[Friend], ErrorMessage>) -> Void) {
        let urlRequest = baseUrl + "/friends.get?fields=photo_100&access_token=\(token)&v=5.124"
        print(urlRequest)
        guard let url = URL(string: urlRequest) else {
            completed(.failure(.invalidUsername))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let friendsResponse = try decoder.decode(FriendsResponse.self, from: data)
                let friends = friendsResponse.response.items
                completed(.success(friends))
                print("################ \(response)")
            } catch {
                print(error)
                completed(.failure(.invalidData))
                return
            }
        }
        
        task.resume()
    }
    
    func getGroups(completed: @escaping (Result<[Group], ErrorMessage>) -> Void) {
        let urlRequest = baseUrl + "/groups.get?extended=1&access_token=\(token)&v=5.124"
        
        guard let url = URL(string: urlRequest) else {
            completed(.failure(.invalidUsername))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let groupsResponse = try decoder.decode(GroupsResponse.self, from: data)
                let groups = groupsResponse.response.items
                completed(.success(groups))
            } catch {
                print(error)
                completed(.failure(.invalidData))
                return
            }
        }
        
        task.resume()
    }
    
//    func getPhotos(for friendId: String, offset: Int, completed: @escaping (Result<[Photo], ErrorMessage>) -> Void) {
//        let urlRequest = baseUrl + "/photos.getAll?owner_id=\(friendId)&access_token=\(token)&v=5.131&count=200&offset=\(offset)"
//
//        guard let url = URL(string: urlRequest) else {
//            completed(.failure(.invalidUsername))
//            return
//        }
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//
//            if let _ = error {
//                completed(.failure(.unableToComplete))
//            }
//
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
//                completed(.failure(.invalidResponse))
//                return
//            }
//
//            guard let data = data else {
//                completed(.failure(.invalidData))
//                return
//            }
//
//            do {
//                let decoder = JSONDecoder()
//                let photosResponse = try decoder.decode(PhotosResponse.self, from: data)
//                let photos = photosResponse.response.items
//                completed(.success(photos))
//            } catch {
//                print(error)
//                completed(.failure(.invalidData))
//                return
//            }
//        }
//
//        task.resume()
//    }
    
    func getPhotos(for friendId: String, offset: Int, completed: @escaping (Result<PhotosResponse, ErrorMessage>) -> Void) {
        let urlRequest = baseUrl + "/photos.getAll?owner_id=\(friendId)&access_token=\(token)&v=5.131&count=200&offset=\(offset)"
        
        guard let url = URL(string: urlRequest) else {
            completed(.failure(.invalidUsername))
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let photosResponse = try decoder.decode(PhotosResponse.self, from: data)
                completed(.success(photosResponse))
            } catch {
                print(error)
                completed(.failure(.invalidData))
                return
            }
        }
        
        task.resume()
    }
    
    func downloadAvatar(from urlString: String, to avatar: UIImageView) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            avatar.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }

            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: cacheKey)
            
            DispatchQueue.main.async { avatar.image = image }
        }

        task.resume()
}
}
