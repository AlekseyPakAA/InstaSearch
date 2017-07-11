
import Foundation
import RealmSwift


class DatabaseInteractor {
    
    var realm = try! Realm()

    func save(media: Media) throws {
        try realm.write {            realm.add(media, update: true)
        }
    }
    
    func save(copyof media: Media) throws {
        let copy = Media(value: media)
        try realm.write {
            realm.add(copy, update: true)
        }
    }
    
    func exists(mediaWith id: String) -> Bool {
        let obj = realm.object(ofType: Media.self, forPrimaryKey: id)
        if obj == nil {
            return false
        } else {
            return true
        }
    }
    
    func delete(id: String) throws {
        realm.beginWrite()
        let object = realm.object(ofType: Media.self, forPrimaryKey: id)
        if let object = object {
            realm.delete(object)
        }
        try realm.commitWrite()
    }
    
    func deleteAll() throws {
        realm.beginWrite()
        let objects = realm.objects(Media.self)
        realm.delete(objects)
        try? realm.commitWrite()
    }
    
    func list() -> Results<Media> {
        let items =  realm.objects(Media.self)
        return items
    }
    
    func object(id:  String) -> Media? {
        let obj = realm.object(ofType: Media.self, forPrimaryKey: id)
        return obj
    }

}

