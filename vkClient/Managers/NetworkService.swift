//
//  NetworkManager.swift
//  vkClient
//
//  Created by Lina Prosvetova on 31.10.2022.
//

import UIKit
import RealmSwift

struct NetworkService {
    static let shared = NetworkService()
    private let baseUrl = "https://api.vk.com/method"
    private let token = Session.shared.token
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getFriends(completed: @escaping (Result<[FriendModel], ErrorMessage>) -> Void) {
        let urlRequest = baseUrl + "/friends.get?fields=photo_100&access_token=\(token)&v=5.124"
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
            } catch {
                completed(.failure(.invalidData))
                return
            }
        }
        
        task.resume()
    }
    
    func getGroups(completed: @escaping (Result<[GroupModel], ErrorMessage>) -> Void) {
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
                completed(.failure(.invalidData))
                return
            }
        }
        
        task.resume()
    }
    
    
    func getSearchGroups(for searchRequest: String, completed: @escaping (Result<[GroupModel], ErrorMessage>) -> Void) {
        let urlComponents = makeUrlComponentsForSearch(with: searchRequest)
        guard let url = urlComponents.url else {
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
                completed(.failure(.invalidData))
                return
            }
        }
        task.resume()
    }
    
    func deleteGroup(for groupId: Int, completed: @escaping (Result<GroupDeleteAddResponse, ErrorMessage>) -> Void) {
        let urlRequest = baseUrl + "/groups.leave?group_id=\(groupId)&access_token=\(token)&v=5.124"
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
                let groupDeleteResponse = try decoder.decode(GroupDeleteAddResponse.self, from: data)
                completed(.success(groupDeleteResponse))
            } catch {
                completed(.failure(.invalidData))
                return
            }
        }
        
        task.resume()
    }
    
    func addGroup(for groupId: Int, completed: @escaping (Result<GroupDeleteAddResponse, ErrorMessage>) -> Void) {
        let urlRequest = baseUrl + "/groups.join?group_id=\(groupId)&access_token=\(token)&v=5.124"
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
                let groupAddResponse = try decoder.decode(GroupDeleteAddResponse.self, from: data)
                completed(.success(groupAddResponse))
            } catch {
                completed(.failure(.invalidData))
                return
            }
        }
        
        task.resume()
    }
    
    func getGroupsList(for groupsIds: String, completed: @escaping (Result<[GroupModel], ErrorMessage>) -> Void) {
        let urlRequest = baseUrl + "/groups.getById?group_ids=\(groupsIds)&access_token=\(token)&v=5.124&fields=members_count"
        
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
                let groupsResponse = try decoder.decode(GroupsListResponse.self, from: data)
                let groups = groupsResponse.response
                completed(.success(groups))
            } catch {
                completed(.failure(.invalidData))
                return
            }
        }
        
        task.resume()
    }
    
    private func makeUrlComponentsForSearch(with query: String) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.search"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "v", value: "5.124")
        ]
        return urlComponents
    }
    
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
