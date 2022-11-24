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
    
    func saveFriends(_ friends: [FriendModel]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(realm.objects(FriendModel.self))
            realm.add(friends, update: .all)
            try  realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func saveGroups(_ groups: [GroupModel]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(realm.objects(GroupModel.self))
            realm.add(groups, update: .all)
            try  realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func loadDataGroups() -> [GroupModel] {
        do {
            let realm = try Realm()
            let groups = realm.objects(GroupModel.self)
            return Array(groups)
        } catch {
            print(error)
            return []
        }
    }
    
    func deleteGroup(groupId: Int) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(realm.objects(GroupModel.self).filter("groupId == %@", groupId))
            try realm.commitWrite()
        } catch  {
            print(error)
        }
    }
    
    func addGroup(group: GroupModel) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(group)
            try realm.commitWrite()
        } catch  {
            print(error)
        }
    }

    func savePhoto(_ photos: [PhotoModel], ownerId: Int, isLoadimgMorePhoto: Bool = false) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            if !isLoadimgMorePhoto {
            realm.delete(realm.objects(PhotoModel.self).filter("ownerId == %@", ownerId))
            }
            realm.add(photos, update: .all)
            try  realm.commitWrite()
        } catch {
            print(error)
        }
    }
}

