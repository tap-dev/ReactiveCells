//
//  CartViewController.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import UIKit

final class CartViewController: UIViewController {
    
    @IBOutlet weak var checkoutBottom: NSLayoutConstraint!
    @IBOutlet weak var checkoutContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        
        
    }
}
