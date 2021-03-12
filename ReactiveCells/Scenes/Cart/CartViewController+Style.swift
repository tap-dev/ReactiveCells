//
//  CartViewController+Style.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import UIKit

extension CartViewController {
    func style() {
        title = "Cart"
        
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
        tableView.tableFooterView = UIView()
        
        checkoutContainer.style(.card)
        totalLabel.style(.title)
        amountLabel.style(.title)
        amountLabel.textColor = .cartRed
        checkoutButton.style(.red, size: .big)
    }
}
