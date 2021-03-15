//
//  CartViewController+DataSource.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import UIKit
import RxDataSources

extension CartViewController {
    
    static let dataSource: RxTableViewSectionedAnimatedDataSource<CartSection> = {
        let animationConfiguration = AnimationConfiguration(insertAnimation: .left, reloadAnimation: .fade, deleteAnimation: .right)
        return RxTableViewSectionedAnimatedDataSource(animationConfiguration: animationConfiguration,
                                                      
          decideViewTransition: { _, _, changeset in
            changeset.isEmpty ? .reload : .animated
          },

          configureCell: { _, tableView, indexPath, row in
            CartCell.from(tableView, at: indexPath, configuredWith: CartCellViewModel(row: row))
          },
              
          canEditRowAtIndexPath: { _, _ in
            false
          })
    }()
}
