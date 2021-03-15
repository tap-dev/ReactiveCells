//
//  CartCell.swift
//  ReactiveCells
//
//  Created by Greg Price on 15/03/2021.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
}

struct CartCellConfigurator {
    
    static func cellFrom(_ tableView: UITableView, at indexPath: IndexPath, configuredWith row: CartRow) -> CartCell {
        guard let product = row.products.first else { fatalError() }
        let cell: CartCell = tableView.dequeueCell(for: indexPath)
        cell.thumbImageView.image = product.productImage
        cell.nameLabel.text = product.title
        cell.priceLabel.text = product.price.decimalCurrencyString
        return cell
    }

//    static func configure(_ cell: CartCell, with row: CartRow) -> CartRow {
//        //cell.thumbImageView.image = basketProduct.product.productImage
//        //cell.nameLabel.text = basketProduct.product.title
//        //cell.priceLabel.text = basketProduct.product.price.decimalCurrencyString
//        return cell
//    }
}
