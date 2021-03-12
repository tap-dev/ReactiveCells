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
            return CartState([])
        case .increment(let product):
            print("INCREMENT")
            return CartState([])
        case .decrement(let product):
            print("DECREMENT")
            return CartState([])
        }
    }
}
