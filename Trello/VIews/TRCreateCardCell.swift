//
//  TRCreateCardCell.swift
//  Trello
//
//  Created by Apple on 4/8/20.
//  Copyright © 2020 Ross Stepaniak. All rights reserved.
//

import UIKit

protocol TRCreateCardCellDelegate: class {
    func onCreateCard()
}

class TRCreateCardCell: UITableViewCell {

    weak var delegate: TRCreateCardCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

   @IBAction func createCardButtonClicked() {
        delegate?.onCreateCard()
    }

}
