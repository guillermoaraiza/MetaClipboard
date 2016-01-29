//
//  MetaClipboard.swift
//  Meta Clipboard
//
//  Created by Guillermo A Araiza Torres on 28/01/16.
//  Copyright © 2016 Disforma. All rights reserved.
//

import Foundation

public class MetaClipboard{
    
    var cloudArray:CloudArray   = CloudArray()
    var metaClipboardItems      = [String]()
    
    init() {
        metaClipboardItems = cloudArray.value!
    }
    
    func update(){
        
        if(cloudArray.value != nil){
            
            metaClipboardItems = cloudArray.value!
            
        }
        
    }
    
    func first() -> String? {
        
        if metaClipboardItems.count > 0{
            
            return metaClipboardItems.first
        
        }else{
            
            return nil
        }
    }
    
    func append(clipboardString: String){
        
        let index = findByString(clipboardString) as Int?
        
        // Remove the repeated element to the array.
        if index != nil {
            remove(index!)
        }
        
        // We push an element to the array.
        metaClipboardItems.insert(clipboardString, atIndex: 0)
        
        // No more than 10 objects in the array.
        if(metaClipboardItems.count > 10){
            let range = Range(start: 10, end: metaClipboardItems.count)
            _ = metaClipboardItems.removeRange(range)
        }
        
        // Update cloud clipboard.
        cloudArray.value = metaClipboardItems
        
    }
    
    
    func find(index: Int) -> String{
        
        let theString = metaClipboardItems[index]
        append(theString)
        return theString
        
    }
    
    
    private func findByString(clipboardString: String) -> Int? {
        
        // We look for the element in the array.
        for(var i=0; i < metaClipboardItems.count; i++){
            if(metaClipboardItems[i] == clipboardString){
                return i
            }
        }
        return nil
    }
    
    
    private func remove(index: Int){
        metaClipboardItems.removeAtIndex(index)
    }
    
    
    
}