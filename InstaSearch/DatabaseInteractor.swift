
import Foundation
import RealmSwift


class DatabaseInteractor {
    
    var realm = try! Realm()

    func save(media: Media) throws {
        try realm.write {
            realm.add(media, update: true)
        }
        
    }
    
    func list() -> Results<Media> {
        let items =  realm.objects(Media.self)
        return items
    }
    
    func object(id:  String) -> Media? {
        return realm.object(ofType: Media.self, forPrimaryKey: id)
    }
    
    func delete(media: Media) throws {
        try! realm.write {
            realm.delete(media)
        }
    }
    
}

