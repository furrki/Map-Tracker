//
//  RunObject.swift
//  MapSave
//
//  Created by Admin on 21.01.2019.
//  Copyright © 2019 furrki. All rights reserved.
//

import Foundation
import RealmSwift


class RunObject: Object {
    @objc dynamic public private(set) var id = ""
    @objc dynamic public private(set) var date = Date()
    @objc dynamic public private(set) var duration = 0
    @objc dynamic public private(set) var dist = 0.0
    
    public let lats = List<Double>()
    public let lons = List<Double>()
    
    static let config = RealmConfig.RunObjectConfig
    static let obj = RunObject.self
    
    
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["unix"]
    }
    
    convenience required init(dist: Double, duration: Int, poses: [[Double]]){
        self.init()
        
        
        self.id = UUID().uuidString.lowercased()
        self.date = Date()
        self.dist = dist
        self.duration = duration
        for pos in poses {
            self.lats.append(pos[0])
            self.lons.append(pos[1])
        }
        
    }
    
    static func insert(dist: Double, duration: Int, poses: [[Double]]){
        REALM_QUEUE.sync {
            do {
            let realm = try Realm(configuration: config)
            try realm.write {
                let run = RunObject(dist: dist, duration: duration, poses: poses)
                realm.add(run)
                try realm.commitWrite()
            }
        } catch {
            
            }
        }
    }
    static func getRuns() -> Results<RunObject>?{
        do {
            let realm = try Realm(configuration: config)
            var comments = realm.objects(obj)
            comments = comments.sorted(byKeyPath: "date")
            return comments
        } catch {
            return nil
        }
    }
    
    static func getMessage(byId id: String) -> RunObject?{
        do {
            let realm = try Realm(configuration: config)
            let msg = realm.object(ofType: obj, forPrimaryKey: id)
            return msg
        } catch {
            return nil
        }
    }
    
    static func removeAll(){
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                realm.deleteAll()
                try realm.commitWrite()
            }
        } catch {
            
        }
    }
}





