//
//  CartState.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import Foundation

struct CartState {
    
    private(set) var sections: [CartSection]
    init(_ sections: [CartSection]) {
        self.sections = sections
    }
    
    func execute(_ action: CartAction) -> CartState {
        guard self.sections.count < 2 else { fatalError("CartState only supports 1 section") }
        switch action {
        
        case .add(let product):
            return CartState([add(product, to: self.sections[0])])
        
        case .increment(_):
            print("INCREMENT")
            return CartState([])
        
        case .decrement(_):
            print("DECREMENT")
            return CartState([])
        }
    }
    
    private func add(_ product: CartProduct, to section: CartSection) -> CartSection {
        if let row = section.row(for: product) {
            let products = row.products + [product]
            let newRow = CartRow(uuid: row.uuid, products: products)
            return section.replacing(newRow)
        
        } else {
            let newRow = CartRow(products: [product])
            let items = section.rows + [newRow]
            return CartSection(original: section, items: items)
        }
    }
}

fileprivate extension CartSection {
    func row(for product: CartProduct) -> CartRow? {
        return rows.filter { $0.products.contains(product) }.first
    }
    
    func replacing(_ row: CartRow) -> CartSection {
        if let index = rows.firstIndex(of: row) {
            var rows = self.rows
            rows[index] = row
            return CartSection(original: self, items: rows)
        } else {
            return self
        }
    }
}

