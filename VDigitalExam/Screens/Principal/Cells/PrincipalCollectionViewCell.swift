//
//  PrincipalCollectionViewCell.swift
//  VDigitalExam
//
//  Created by Cristian on 02-04-21.
//

import UIKit

protocol PrincipalCollectionViewCellDelegate: AnyObject {
    func itemDeleted()
}

class PrincipalCollectionViewCell: UICollectionViewCell {

    var objectID = ""
    var delegate: PrincipalCollectionViewCellDelegate?

    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceTimeLabel: UILabel!
    @IBOutlet weak var deleteView: UIView!
    @IBOutlet weak var deleteViewWidthConstraint: NSLayoutConstraint!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // This function setups the cell injection the model
    public func setup(model: PrincipalCollectionViewCellModel, delegate: PrincipalCollectionViewCellDelegate) {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(otherDeleteButtonTapped(_:)),
            name: .deleteButtonTapped,
            object: nil
        )
        self.delegate = delegate
        self.objectID = model.objectID
        self.titleLabel.text = model.title
        self.titleLabel.numberOfLines = 2
        self.sourceTimeLabel.text = model.sourceTime
        self.deleteView.isUserInteractionEnabled = true
        addGesture(direction: .left, selector: #selector(didSwipeLeft(_:)))
        addGesture(direction: .right, selector: #selector(didSwipeRight(_:)))
    }

    @IBAction func deleteButtonTapped(_ sender: Any) {
        print("deleteButtonTapped-objectID: \(objectID)")
        hideDeleteView()
        LocalStorage.addDeletedNew(value: objectID)
        if let delegate = self.delegate {
            delegate.itemDeleted()
        }
    }

    func showDeleteView() {
        UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: { [weak self] in
                            if let self = self {
                                self.deleteViewWidthConstraint.constant = 80
                                self.contentView.layoutIfNeeded()
                            }
            }, completion: nil)
    }

    func hideDeleteView() {
        UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: [.curveEaseOut],
                           animations: { [weak self] in
                            if let self = self {
                                self.deleteViewWidthConstraint.constant = 0
                                self.contentView.layoutIfNeeded()
                            }
            }, completion: nil)
    }

    func addGesture(
        direction: UISwipeGestureRecognizer.Direction,
        selector: Selector
    ) {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(
            target: self,
            action: selector
        )
        swipeGestureRecognizer.direction = direction
        self.contentView.addGestureRecognizer(swipeGestureRecognizer)
    }

    @objc
    private func didSwipeLeft(_ sender: UISwipeGestureRecognizer) {
        print("didSwipeLeft()")
        showDeleteView()

        NotificationCenter.default.post(
            name: .deleteButtonTapped,
            object: self.objectID
        )
    }

    @objc
    private func didSwipeRight(_ sender: UISwipeGestureRecognizer) {
        print("didSwipeRight()")
        hideDeleteView()
    }

    @objc
    private func otherDeleteButtonTapped(_ notification: Notification) {
        let receivedObjectID = notification.object as? String ?? ""
        if receivedObjectID != objectID {
            hideDeleteView()
        }
    }
}

public struct PrincipalCollectionViewCellModel {
    let objectID: String
    let title: String
    let sourceTime: String
    let urlString: String
}

extension Notification.Name {
    static let deleteButtonTapped = Notification.Name("deleteButtonTapped")
}
