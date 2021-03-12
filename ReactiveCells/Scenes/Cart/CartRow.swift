//
//  CartRow.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import Foundation
import RxDataSources

struct CartRow {
    let uuid: UUID
    let products: [CartProduct]
}

extension CartRow {
    init(products: [CartProduct]) {
        self.uuid = UUID()
        self.products = products
    }
    
    init(original: CartRow, products: [CartProduct]) {
        self.uuid = original.uuid
        self.products = products
    }
}

extension CartRow : IdentifiableType, Equatable {
    var identity: UUID {
        return uuid
    }
}

func ==(lhs: CartRow, rhs: CartRow) -> Bool {
    return lhs.uuid == rhs.uuid
}
