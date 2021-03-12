//
//  CartState.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

struct CartState {
    
    private(set) var sections: [CartSection]
    init(_ sections: [CartSection]) {
        self.sections = sections
    }
    
    func execute(_ action: CartAction) -> CartState {
        guard self.sections.count == 1 else { fatalError("CartState only supports 1 section") }
        switch action {
        
        case .add(let product):
            print("ADD")
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
        
        // does row already exist with this product in
        // yes = append the product to the row.products
        // ... = return new cart section, with updated row
        // no = create new row with this product
        // ... = return new cart section, with row added
        
        if let row = section.row(for: product) {
            let products = row.products + [product]
            let newRow = CartRow(original: row, products: products)
            return section.section(replacing: newRow)
        
        } else {
            let newRow = CartRow(products: [product])
            let items = section.rows + [newRow]
            let section = CartSection(original: section, items: items)
            return section
        }
    }
}

fileprivate extension CartSection {
    func row(for product: CartProduct) -> CartRow? {
        return rows.filter { $0.products.contains(product) }.first
    }
    
    func section(replacing row: CartRow) -> CartSection {
        if let index = rows.firstIndex(of: row) {
            var rows = self.rows
            rows[index] = row
            let section = CartSection(original: self, items: rows)
            return section
        } else {
            return self
        }
    }
}

