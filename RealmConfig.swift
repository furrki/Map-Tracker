//
//  RealmConfig.swift
//  MapSave
//
//  Created by Admin on 21.01.2019.
//  Copyright © 2019 furrki. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {

    static var RunObjectConfig: Realm.Configuration {
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        let config = Realm.Configuration(
            fileURL: realmPath,
            schemaVersion: 3,
            migrationBlock:{ migration, oldSchemaVersion in
                if(oldSchemaVersion < 0) {
                    
                }
        })
        return config
    }
}
