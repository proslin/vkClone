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
    
    func saveFriends(_ friends: [Friend]) {
        do {
//            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//            let realm = try Realm(configuration: config, queue: DispatchQueue.main)
            // получаем доступ к хранилищу
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
            // начинаем изменять хранилище
            realm.beginWrite()
            // удаляем старые данные
            realm.delete(realm.objects(Friend.self))
            // кладем все объекты класса погоды в хранилище
            realm.add(friends, update: .all)
            // завершаем изменять хранилище
            try  realm.commitWrite()
        } catch {
            // если произошла ошибка, выв
            print(error)
        }
    }
    
    func saveGroups(_ groups: [Group]) {
        do {
//            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//            let realm = try Realm(configuration: config, queue: DispatchQueue.main)
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
            realm.beginWrite()
            // удаляем старые данные
            realm.delete(realm.objects(Group.self))
            // кладем все объекты класса погоды в хранилище
            realm.add(groups, update: .all)
            // завершаем изменять хранилище
            try  realm.commitWrite()
        } catch {
            // если произошла ошибка, выв
            print(error)
        }
    }
    
    func loadDataGroups() -> [Group] {
        do {
            let realm = try Realm()
            
            let groups = realm.objects(Group.self)
            
            //self.  = Array(weathers)
            return Array(groups)
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
            return []
        }
    }
    
    func deleteGroup(groupId: Int) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.delete(realm.objects(Group.self).filter("groupId == %@", groupId))
            try realm.commitWrite()
        } catch  {
            print(error)
        }
    }
    
    func addGroup(group: Group) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(group)
            try realm.commitWrite()
        } catch  {
            print(error)
        }
    }
    
//    func savePhoto(_ photos: [Photo], ownerId: Int, isLoadimgMorePhoto: Bool = false) {
//        do {
////            Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
////            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
////            let realm = try Realm(configuration: config, queue: DispatchQueue.main)
//            let realm = try Realm()
//            print(realm.configuration.fileURL as Any)
//            // все старые погодные данные для текущего города
//            // let oldWeathers = realm.objects(Weather.self).filter("city == %@", city)
//            // начинаем изменять хранилище
//            realm.beginWrite()
//            // удаляем старые данные если загружаем заново
//            if !isLoadimgMorePhoto {
//            realm.delete(realm.objects(PhotoObject.self).filter("owner.friendId == %@", ownerId))
//            }
//            //realm.delete(realm.objects(PhotoObject.self))
//            // ищем владельца фото по ID
//            let owner = realm.objects(Friend.self).filter("friendId == %@", ownerId).first!
//            // добавляем в хранилище, предварительно сконвертировав
//            realm.add(convertToPhotoObject(photos: photos, owner: owner.friendId), update: .all)
//            // завершаем изменять хранилище
//            try  realm.commitWrite()
//        } catch {
//            // если произошла ошибка, выв
//            print(error)
//        }
//    }
    
    func savePhoto(_ photos: [Photo], ownerId: Int, isLoadimgMorePhoto: Bool = false) {
        do {
//            Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//            let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
//            let realm = try Realm(configuration: config, queue: DispatchQueue.main)
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
            // начинаем изменять хранилище
            realm.beginWrite()
            // удаляем старые данные если загружаем заново
            if !isLoadimgMorePhoto {
            realm.delete(realm.objects(Photo.self).filter("ownerId == %@", ownerId))
            }
            realm.add(photos, update: .all)
            // завершаем изменять хранилище
            try  realm.commitWrite()
        } catch {
            // если произошла ошибка, выв
            print(error)
        }
    }
    
    func loadDataPhoto(ownerId: Int) -> [PhotoObject] {
        do {
            let realm = try Realm()
            
            let photos = realm.objects(PhotoObject.self).filter("owner.friendId == %@", ownerId)
            return Array(photos)
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
            return []
        }
    }
    
    func convertToPhotoObject(photos: [Photo], owner: Int) -> [PhotoObject] {
            var photosObj: [PhotoObject] = []
            for photo in photos {
                let photoObj = PhotoObject(photoId: photo.id, photoURL: photo.photoURL, owner: owner)
                photosObj.append(photoObj)
            }
            return photosObj
        }
    
    func loadDataFriends() -> [Friend] {
        do {
            let realm = try Realm()
            
            let friends = realm.objects(Friend.self)
            
            //self.  = Array(weathers)
            return Array(friends)
        } catch {
            // если произошла ошибка, выводим ее в консоль
            print(error)
            return []
        }
    }
}

