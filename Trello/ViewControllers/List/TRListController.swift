//
//  TRCardsController.swift
//  Trello
//
//  Created by Apple on 4/8/20.
//  Copyright © 2020 Ross Stepaniak. All rights reserved.
//

import UIKit

protocol ListPresentable: class {
    func onListsLoaded()
}

class TRListController: NSObject {
    weak var presentable: ListPresentable?
    private var storage = TRStorage()
    private var lists: [List]!
    
    func loadLists() {
        lists = storage.fetchLists()
        presentable?.onListsLoaded()
    }
    
    func searchLists(_ searchText: String) {
        lists = searchText.isEmpty ? storage.fetchLists() : storage.fetchLists().filter({(list: List) -> Bool in
            let listName = list.name.range(of: searchText, options: .caseInsensitive) != nil
            return listName
        })
        
        presentable?.onListsLoaded()
    }
    
    func resetSearch() {
        loadLists()
    }
    
    func list(index: NSInteger) -> List? {
        if lists.count > index {
            return lists[index]
        }
        return nil
    }
    
    func numberOfLists() -> NSInteger {
        return lists.count
    }
    
    func addList(_ listName: String) {
        storage.addList(listName)
        loadLists()
    }
}
