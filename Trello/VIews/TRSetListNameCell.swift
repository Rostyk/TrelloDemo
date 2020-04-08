//
//  TrelloSetListNameCell.swift
//  Trello
//
//  Created by Apple on 4/8/20.
//  Copyright © 2020 Ross Stepaniak. All rights reserved.
//

import UIKit

protocol TRSetListNameCellDelegate: class {
    func onListCreated(_ listName: String)
    func onListCancelled()
}

class TRSetListNameCell: UITableViewCell {

    weak var delegate: TRSetListNameCellDelegate?
    @IBOutlet weak var listNameTextField: UITextField!
    @IBOutlet weak var acceptButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        acceptButton.setImage(UIImage(named:  "icon-accept-disabled"), for: .normal)
        acceptButton.isUserInteractionEnabled = false
    }
    
    @IBAction private func acceptButtonClicked() {
        listNameTextField.resignFirstResponder()
        delegate?.onListCreated(listNameTextField.text!)
    }
    
    @IBAction private func cancelButtonClicked() {
        listNameTextField.resignFirstResponder()
        delegate?.onListCancelled()
    }
    
    func disableAcceptButton() {
        acceptButton.setImage(UIImage(named:  "icon-accept-disabled"), for: .normal)
        acceptButton.isUserInteractionEnabled = false
    }
    
    func enableAcceptButton() {
        acceptButton.setImage(UIImage(named:  "icon-accept-active"), for: .normal)
        acceptButton.isUserInteractionEnabled = true
    }
}

extension TRSetListNameCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.isEmpty {
           disableAcceptButton()
        }
        else {
            enableAcceptButton()
        }
       
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.count > 0 {
            delegate?.onListCreated(listNameTextField.text!)
        }
        
        textField.resignFirstResponder()
        return true
    }
}
