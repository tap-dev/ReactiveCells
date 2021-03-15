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
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
}

extension CartCell {
    static func from(_ tableView: UITableView, at indexPath: IndexPath, configuredWith viewModel: CartCellViewModel) -> CartCell {
        let cell: CartCell = tableView.dequeueCell(for: indexPath)
        cell.thumbImageView.image = viewModel.image
        cell.nameLabel.text = viewModel.name
        cell.priceLabel.text = viewModel.price
        cell.countLabel.text = viewModel.count
        return cell
    }
}

struct CartCellViewModel {
    let row: CartRow
    var product: CartProduct? { row.products.first }
    var image: UIImage? { product?.productImage }
    var name: String? { product?.title }
    var price: String? { product?.price.decimalCurrencyString }
    var count: String { "\(row.products.count)" }
}
