//
//  PrincipalCollectionViewCell.swift
//  VDigitalExam
//
//  Created by Cristian on 02-04-21.
//

import UIKit

class PrincipalCollectionViewCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceTimeLabel: UILabel!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // This function setups the cell injection the model
    public func setup(model: PrincipalCollectionViewCellModel) {
        self.titleLabel.text = model.title
        self.sourceTimeLabel.text = model.sourceTime
    }
}

public struct PrincipalCollectionViewCellModel {
    let title: String
    let sourceTime: String
    let urlString: String
}
