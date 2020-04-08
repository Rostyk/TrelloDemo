//
//  TRSetCardNameCell.swift
//  Trello
//
//  Created by Apple on 4/8/20.
//  Copyright © 2020 Ross Stepaniak. All rights reserved.
//

import UIKit

protocol TRSetCardNameCellDelegate: NSObject {
    func onCardCreated(_ cardName: String)
    func onCardCancelled()
}

class TRSetCardNameCell: UITableViewCell {

    weak var delegate: TRSetCardNameCellDelegate?
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var acceptButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction private func acceptButtonClicked() {
        delegate?.onCardCreated(cardNameTextField.text!)
    }
    
    @IBAction private func cancelButtonClicked() {
        delegate?.onCardCancelled()
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

extension TRSetCardNameCell: UITextFieldDelegate {
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
            delegate?.onCardCreated(cardNameTextField.text!)
        }
        
        textField.resignFirstResponder()
        return true
    }
}

