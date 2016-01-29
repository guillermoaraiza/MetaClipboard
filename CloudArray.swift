//
//  KeyValueStorage.swift
//  Meta Clipboard
//
//  Created by Guillermo A Araiza Torres on 28/01/16.
//  Copyright © 2016 Disforma. All rights reserved.
//

import Foundation

struct CloudArray {
    
    let ActivityItemKey  = "com.disforma.Meta-Clipboard.items.key"
    var value : [String]? {
        
        get
        {
            return NSUbiquitousKeyValueStore.defaultStore().objectForKey(ActivityItemKey) as? Array
        }
        
        set
        {
            
            NSUbiquitousKeyValueStore
                                    .defaultStore()
                                    .setObject(newValue, forKey: ActivityItemKey)
            
            NSUbiquitousKeyValueStore.defaultStore().synchronize()
            
        }
    }
    
}