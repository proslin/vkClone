//
//  RealmManager.swift
//  vkClient
//
//  Created by Lina Prosvetova on 07.11.2022.
//

import Foundation
import RealmSwift

struct RealmService {
    static let shared = RealmService()
    
    private init() {}
    
    public func saveFriends(_ friends: [Friend]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(realm.objects(Friend.self))
            realm.add(friends, update: .all)
            try  realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    public func saveGroups(_ groups: [Group]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(realm.objects(Group.self))
            realm.add(groups, update: .all)
            try  realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    public func loadDataGroups() -> [Group] {
        do {
            let realm = try Realm()
            let groups = realm.objects(Group.self)
            return Array(groups)
        } catch {
            print(error)
            return []
        }
    }
    
    public func deleteGroup(groupId: Int) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(realm.objects(Group.self).filter("groupId == %@", groupId))
            try realm.commitWrite()
        } catch  {
            print(error)
        }
    }
    
    public func addGroup(group: Group) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(group)
            try realm.commitWrite()
        } catch  {
            print(error)
        }
    }

    public func savePhoto(_ photos: [Photo], ownerId: Int, isLoadimgMorePhoto: Bool = false) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
            realm.beginWrite()
            if !isLoadimgMorePhoto {
            realm.delete(realm.objects(Photo.self).filter("ownerId == %@", ownerId))
            }
            realm.add(photos, update: .all)
            try  realm.commitWrite()
        } catch {
            print(error)
        }
    }
}

