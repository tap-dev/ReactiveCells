//
//  CartViewModel.swift
//  ReactiveCells
//
//  Created by Greg Price on 12/03/2021.
//

import RxSwift

struct CartInput {
    let addProduct: Observable<Void>
    let checkout: Observable<Void>
}

struct CartOutput {
    let cart: Observable<[CartSection]>
    let cartTotal: Observable<String?>
    let cartEmpty: Observable<Bool>
    let checkoutVisible: Observable<(visible: Bool, animated: Bool)>
}

enum CartAction {
    case add(CartProduct)
    case increment(CartProduct)
    case decrement(CartProduct)
}

struct CartViewModel {
    
    private let incrementProductSubject = PublishSubject<CartProduct>()
    private let decrementProductSubject = PublishSubject<CartProduct>()
    var incrementProduct: AnyObserver<CartProduct> { incrementProductSubject.asObserver() }
    var decrementProduct: AnyObserver<CartProduct> { decrementProductSubject.asObserver() }
    
    func bind(_ input: CartInput) -> CartOutput {
    
        let cart = Observable
            .merge(
                input.addProduct.map(randomProduct()),
                incrementProductSubject.map(incrementedProduct()),
                decrementProductSubject.map(decrementedProduct()))
            .scan(CartState([CartSection([])])) { (state, action) in
                state.execute(action)
            }
            .map { $0.sections }
            .share()
        
        return CartOutput(
            cart: cart,
            cartTotal: cart.map(cartTotal()),
            cartEmpty: cart.map(cartEmpty()),
            checkoutVisible: cart.map(checkoutVisible()).startWith((visible: false, animated: false)))
    }
    
    func randomProduct() -> () -> CartAction {
        { CartAction.add(CartProduct.all.randomElement()!) }
    }
    
    func incrementedProduct() -> (_ product: CartProduct) -> CartAction {
        { CartAction.increment($0) }
    }
    
    func decrementedProduct() -> (_ product: CartProduct) -> CartAction {
        { CartAction.decrement($0) }
    }
    
    func cartTotal() -> (_ cart: [CartSection]) -> String? {
        { $0[safe: 0]?.sectionTotal.decimalCurrencyString }
    }
    
    func cartEmpty() -> (_ cart: [CartSection]) throws -> Bool {
        { $0[safe: 0]?.rows.count == 0 }
    }
    
    func checkoutVisible() -> (_ cart: [CartSection]) throws -> (visible: Bool, animated: Bool) {
        { $0[safe: 0]?.rows.count == 0 ? (visible: false, animated: true) : (visible: true, animated: true) }
    }
}
