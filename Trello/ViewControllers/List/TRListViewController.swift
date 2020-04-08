//
//  ViewController.swift
//  Trello
//
//  Created by Apple on 4/8/20.
//  Copyright © 2020 Ross Stepaniak. All rights reserved.
//

import UIKit

private enum ListScreenMode {
    case initial
    case createList
    case displayLists
}

class TRListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var mode: ListScreenMode = .initial {
        didSet {
            tableView.alpha = 0.0
            tableView.reloadData()
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.tableView.alpha = 1.0
            }
        }
    }
    
    fileprivate lazy var controller: TRListController = {
        let controller = TRListController()
        controller.presentable = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        controller.loadLists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

extension TRListViewController: ListPresentable {
    func onListsLoaded() {

        if controller.numberOfLists() > 0 {
            mode = .displayLists
        }
        
        tableView.reloadData()
    }
}

extension TRListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if mode == .createList {
            let cell = tableView.cellForRow(at: indexPath) as! TRSetListNameCell
            cell.listNameTextField.becomeFirstResponder()
        }
        
        if mode == .displayLists {
            if (indexPath.row != controller.numberOfLists()) {
                tableView.deselectRow(at: indexPath, animated: true)
                
                let list = controller.list(index: indexPath.row)
                let cardsViewController =
                    storyboard!.instantiateViewController(withIdentifier: "TRCardsViewController") as! TRCardsViewController
                cardsViewController.listName = list?.name
                self.navigationController?.pushViewController(cardsViewController, animated: true)
            }
        }
    }
}

extension TRListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mode == .initial || mode == .createList{
            return 1
        }
        
        // + 1 is the create item cell
        
        if mode == .displayLists {
            return controller.numberOfLists() + 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if mode == .createList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TRSetListNameCell") as! TRSetListNameCell
            cell.listNameTextField.text = ""
            cell.disableAcceptButton()
            cell.delegate = self
            return cell
            
        }
        
        if mode == .displayLists {
            if (indexPath.row == controller.numberOfLists()) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TRCreateListCell") as! TRCreateListCell
                cell.delegate = self
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TRListCell") as! TRListCell
                cell.listNameTextField.text = controller.list(index: indexPath.row)?.name
                return cell
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TRCreateListCell") as! TRCreateListCell
        cell.delegate = self
        return cell
    }
}

extension TRListViewController: TRCreateListCellDelegate {
    func onCreateList() {
        mode = .createList
    }
}

extension TRListViewController: TRSetListNameCellDelegate {
    func onListCreated(_ listName: String) {
        controller.addList(listName)
        mode = .displayLists
    }
    
    func onListCancelled() {
        mode = .displayLists
    }
}

extension TRListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                           searchBar.resignFirstResponder()
                
                self?.controller.resetSearch()
                searchBar.resignFirstResponder()
            }
           
        }
        else {
            controller.searchLists(searchBar.text!)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}


