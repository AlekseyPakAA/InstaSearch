
import Foundation
import RealmSwift


class DatabaseInteractor {
    
    var realm = try! Realm()

    func save(media: Media) {
        try! realm.write {
            realm.add(media, update: true)
        }
    }
    
    
    func list() -> Results<Media> {
        let items =  realm.objects(Media.self)
        return items
    }
    
    func object(id:  String) -> Media? {
        let obj = realm.object(ofType: Media.self, forPrimaryKey: id)
        return obj
    }
    
    func delete(media: Media) {
        try! realm.write {
            realm.delete(media)
        }
    }
    
    func delete(media: [Media]) {
        try! realm.write {
            realm.delete(media)
        }
    }
    
    func set(media: Media, bookmarks: Bool) {
        try! realm.write {
            media.bookmarks = bookmarks
        }
    }
    
    func set(media: [Media], bookmarks: Bool) {
        try! realm.write {
            media.forEach {$0.bookmarks = bookmarks}
        }
    }
}

