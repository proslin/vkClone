//
//  RealmService.swift
//  vkClient
//
//  Created by Lina Prosvetova on 07.11.2022.
//

import Foundation
import RealmSwift

struct RealmService {
    static let shared = RealmService()
    
    private init() {}
    
    func saveFriends(_ friends: [FriendModel]) -> Error? {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(realm.objects(FriendModel.self))
            realm.add(friends, update: .all)
            try  realm.commitWrite()
            return nil
        } catch {
            return error
        }
    }
    
    func saveGroups(_ groups: [GroupModel]) -> Error? {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(realm.objects(GroupModel.self))
            realm.add(groups, update: .all)
            try  realm.commitWrite()
            return nil
        } catch {
            return error
        }
    }
    
    func deleteGroup(groupId: Int) -> Error? {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(realm.objects(GroupModel.self).filter("groupId == %@", groupId))
            try realm.commitWrite()
            return nil
        } catch  {
            return error
        }
    }
    
    func addGroup(group: GroupModel) -> Error? {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(group)
            try realm.commitWrite()
            return nil
        } catch  {
            return error
        }
    }
    
    func savePhoto(_ photos: [PhotoModel], ownerId: Int, isLoadimgMorePhoto: Bool = false) -> Error? {
        do {
            let realm = try Realm()
            realm.beginWrite()
            if !isLoadimgMorePhoto {
                realm.delete(realm.objects(PhotoModel.self).filter("ownerId == %@", ownerId))
            }
            realm.add(photos, update: .all)
            try  realm.commitWrite()
            return nil
        } catch {
            return error
        }
    }
}

