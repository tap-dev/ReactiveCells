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
    let cartTotal: Observable<String>
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
        
        //        let increment = incrementProductSubject
        //            .asObservable()
        //
        //        let decrement = decrementProductSubject
        //            .asObservable()
        
        let cart = Observable
            .merge(
                input.addProduct.map(randomProduct()))
            .scan(CartState([CartSection([])])) { (state, action) in
                state.execute(action)
            }
            .map { $0.sections }
            .share()
        
        let cartTotal = cart
            .map { $0[0].sectionTotal }
            .map { $0.decimalCurrencyString }
        
        let cartEmpty = cart
            .map { $0[0].rows }
            .map { $0.count == 0 }
        
        let checkoutVisible = cart
            .map { $0[0].rows.count }
            .map { $0 == 0 ? (visible: false, animated: true) : (visible: true, animated: true) }
            .startWith((visible: false, animated: false))

        return CartOutput(
            cart: cart,
            cartTotal: cartTotal,
            cartEmpty: cartEmpty,
            checkoutVisible: checkoutVisible)
    }
    
    func randomProduct() -> () -> CartAction {
        { CartAction.add(CartProduct.all.randomElement()!) }
    }
}
