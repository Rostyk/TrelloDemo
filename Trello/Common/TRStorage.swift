//
//  TRStorage.swift
//  Trello
//
//  Created by Apple on 4/8/20.
//  Copyright © 2020 Ross Stepaniak. All rights reserved.
//
// Just a mock of very simple storage, no interfaces declared

import UIKit

class TRStorage: NSObject {
    private let saveKey = "test_key"
    private var data:[String: [String]]!
    
    override init() {
        if let savedData = UserDefaults.standard.value(forKey: saveKey) as? [String: [String]] {
            data = savedData
        }
        else {
            data = [String: [String]]()
        }
    }
   
    func fetchLists() -> [List] {
        let lists = data.keys.map { (key) -> List in
            List(name: key)
        }
        
        return lists
    }
    
    func fetchCards(_ listName: String) -> [Card] {
        let cardNames = data[listName]
        let cards = cardNames?.map({ (cardName) -> Card in
            Card(name: cardName)
        })
        
        return cards!
    }
    
    func addList(_ name: String) {
        data[name] = []
        UserDefaults.standard.set(data, forKey:saveKey)
    }
    
    func addCard(_ listName: String!, _ cardName: String) {
        var cards = data[listName]
        cards?.append(cardName)
        
        data[listName] = cards
        
        UserDefaults.standard.set(data, forKey:saveKey)
    }
}
