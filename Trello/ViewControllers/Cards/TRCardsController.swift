//
//  TRCardsController.swift
//  Trello
//
//  Created by Apple on 4/8/20.
//  Copyright © 2020 Ross Stepaniak. All rights reserved.
//

import UIKit

protocol CardsPresentable: class {
    func onCardsLoaded()
}

class TRCardsController: NSObject {
    weak var presentable: CardsPresentable?
    
    var listName: String!
    private var storage = TRStorage()
    private var cards: [Card]!
    
    func loadCards() {
        cards = storage.fetchCards(listName)
        presentable?.onCardsLoaded()
    }
    
    func resetSearch() {
        loadCards()
    }
    
    func searchCards(_ searchText: String) {
        cards = searchText.isEmpty ? storage.fetchCards(listName) : storage.fetchCards(listName).filter({(card: Card) -> Bool in
            let cardName = card.name.range(of: searchText, options: .caseInsensitive) != nil
            return cardName
        })
        
        presentable?.onCardsLoaded()
    }
    
    func card(_ listName: String, index: NSInteger) -> Card? {
         if (cards.count > index) {
            return cards[index]
        }
        
        return nil
    }
    
    func numberOfCards() -> NSInteger {
        return cards.count
    }
    
    func addCard(cardName: String) {
        storage.addCard(listName, cardName)
        loadCards()
    }
}
