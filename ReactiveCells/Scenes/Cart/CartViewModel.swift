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
    let showCheckout: Observable<Void>
    let hideCheckout: Observable<Void>
}

enum CartAction {
    case add(CartProduct)
    case increment(CartProduct)
    case decrement(CartProduct)
}

struct CartViewModel {
    
    private let incrementProductSubject = PublishSubject<CartProduct>()
    private let decrementProductSubject = PublishSubject<CartProduct>()
    
    var incrementProduct: AnyObserver<CartProduct> {
        return incrementProductSubject.asObserver()
    }
    
    var decrementProduct: AnyObserver<CartProduct> {
        return decrementProductSubject.asObserver()
    }
    
    func transform(_ input: CartInput) -> CartOutput {
        
        let cart = Observable.merge(input.addProduct.map(randomProduct()))
            .scan(CartState([])) { (state, action) in
                state.execute(action)
            }
            .map { $0.sections }
        
//        let increment = incrementProductSubject
//            .asObservable()
//
//        let decrement = decrementProductSubject
//            .asObservable()
        
        return CartOutput(
            cart: cart,
            cartTotal: .just(""),
            cartEmpty: .just(true),
            showCheckout: .just(()),
            hideCheckout: .never())
    }
    
    func randomProduct() -> () -> CartAction {
        { CartAction.add(CartProduct.all.randomElement()!) }
    }
}
