//
//  CartViewController.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class CartViewController: UIViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutBottom: NSLayoutConstraint!
    @IBOutlet weak var checkoutContainer: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    private let viewModel = CartViewModel()
    private var disposeBag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        let output = viewModel.bind(CartInput(addProduct: rx.addProduct, checkout: rx.checkout))
        
        disposeBag = DisposeBag {
            output.cart.bind(to: tableView.rx.items(dataSource: CartViewController.dataSource))
            output.cartEmpty.bind(to: tableView.rx.isEmpty(message: "Your cart is empty"))
            output.cartTotal.bind(to: amountLabel.rx.text)
            output.checkoutVisible.bind(to: rx.isCheckoutVisible)
        }
    }
}
