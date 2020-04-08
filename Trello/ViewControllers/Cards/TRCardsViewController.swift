//
//  TRCardsViewController.swift
//  Trello
//
//  Created by Apple on 4/8/20.
//  Copyright © 2020 Ross Stepaniak. All rights reserved.
//

import UIKit

private enum CardsScreenMode {
    case createCard
    case displayCards
}

class TRCardsViewController: UIViewController {

    var listName: String!
    @IBOutlet weak var tableView: UITableView!
    
    private var mode: CardsScreenMode = .displayCards {
        didSet {
            tableView.alpha = 0.0
            tableView.reloadData()
            
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.tableView.alpha = 1.0
            }
        }
    }
    
    fileprivate lazy var controller: TRCardsController = {
        let controller = TRCardsController()
        controller.listName = listName
        controller.presentable = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.loadCards()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupTitleAttributes()
        self.navigationController?.navigationBar.isHidden = false
        title = listName
    }
    
    func setupTitleAttributes() {
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0),
            NSAttributedString.Key.font: UIFont(name: "Helvetica-Light", size: 18)!,
        ]
        navigationController?.navigationBar.titleTextAttributes = attrs
    }
}

extension TRCardsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == .createCard {
            let cell = tableView.cellForRow(at: indexPath) as! TRSetCardNameCell
            cell.cardNameTextField.becomeFirstResponder()
        }
    }
}

extension TRCardsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        // + 1 is the create item cell
        if mode == .displayCards {
            return controller.numberOfCards() + 1
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if mode == .createCard {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TRSetCardNameCell") as! TRSetCardNameCell
            cell.cardNameTextField.text = ""
            cell.disableAcceptButton()
            cell.delegate = self
            return cell
            
        }
        
        if mode == .displayCards {
            if (indexPath.row == controller.numberOfCards()) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TRCreateCardCell") as! TRCreateCardCell
                cell.delegate = self
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TRCardCell") as! TRCardCell
                cell.cardNameTextField.text = controller.card(listName, index: indexPath.row)?.name
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TRCreateCardCell") as! TRCreateCardCell
        cell.delegate = self
        return cell
    }
}

extension TRCardsViewController: TRCreateCardCellDelegate {
    func onCreateCard() {
        mode = .createCard
    }
}

extension TRCardsViewController: TRSetCardNameCellDelegate {
    func onCardCreated(_ cardName: String) {
        controller.addCard(cardName: cardName)
        mode = .displayCards
    }
    
    func onCardCancelled() {
        mode = .displayCards
    }
}

extension TRCardsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                           searchBar.resignFirstResponder()
                
                self?.controller.resetSearch()
                searchBar.resignFirstResponder()
            }
        }
        else {
            controller.searchCards(searchBar.text!)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}


extension TRCardsViewController: CardsPresentable {
    func onCardsLoaded() {
        tableView.reloadData()
    }
}

