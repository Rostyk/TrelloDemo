//
//  TrelloCreateListCell.swift
//  Trello
//
//  Created by Apple on 4/8/20.
//  Copyright © 2020 Ross Stepaniak. All rights reserved.
//

import UIKit

protocol TRCreateListCellDelegate: class {
    func onCreateList()
}

class TRCreateListCell: UITableViewCell {

    weak var delegate: TRCreateListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func createListButtonClicked() {
        delegate?.onCreateList()
    }
}
