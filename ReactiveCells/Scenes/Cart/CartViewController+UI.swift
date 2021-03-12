//
//  CartViewController+UI.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import UIKit
import RxSwift

extension CartViewController {
    
    func styleView() {
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
    
    fileprivate func checkout() -> Observable<UIViewController.AlertAction> {
        return alert(title: "Complete Order",
                     message: "Would you like to checkout now and complete your order?",
                     defaultTitle: "Checkout",
                     cancelTitle: "Cancel")
    }
    
    fileprivate func showCheckout() {
        UIView.animate(withDuration: 0.3) {
            self.checkoutBottom.constant = 12
            self.view.layoutIfNeeded()
        }
    }
    
    func hideCheckout() {
        UIView.animate(withDuration: 0.3) {
            self.checkoutBottom.constant = -200
            self.view.layoutIfNeeded()
        }
    }
}

extension Reactive where Base: CartViewController {
    
    var addProduct: Observable<Void> {
        base.addButton.rx.tap
            .map { _ in }
    }
    
    var checkout: Observable<Void> {
        base.checkoutButton.rx.tap
            .withUnretained(base)
            .flatMapLatest { s, _ in s.checkout() }
            .filter { $0 == .default }
            .map { _ in }
    }
    
    func isCheckoutVisible() -> Binder<Bool> {
        return Binder(base) { vc, visible in
            if visible {
                vc.showCheckout()
            } else {
                vc.hideCheckout()
            }
        }
    }
}
