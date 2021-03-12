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
              
          configureCell: { _, tableView, indexPath, item in
            return UITableViewCell()
          },
              
          canEditRowAtIndexPath: { _, _ in
            return false
          })
    }()
}
