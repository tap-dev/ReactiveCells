# Reactive Cells

An example of binding events from custom controls inside of table view cells, to the business logic of a view model. This demo illustrates this technique using a checkout UI where multiple products of the same type can be added or removed using a stepper style component inside of each cell.

The view model has 2 private subjects, one for incrementing a product and another for decrementing a product. These are safely exposed to the outside world as observers.

```swift
private let incrementProductSubject = PublishSubject<CartProduct>()
private let decrementProductSubject = PublishSubject<CartProduct>()

var incrementProduct: AnyObserver<CartProduct> { incrementProductSubject.asObserver() }
var decrementProduct: AnyObserver<CartProduct> { decrementProductSubject.asObserver() }

    func bind(_ input: CartInput) -> CartOutput {

        let cart = Observable
            .merge(
                input.addProduct.map { CartAction.add(CartProduct.random()) },
                input.checkout.map { CartAction.checkout },
                incrementProductSubject.map { CartAction.increment($0) },
                decrementProductSubject.map { CartAction.decrement($0) })

            .scan(CartState.empty()) { (state, action) in
                state.execute(action)
            }
            .map { $0.sections }
            .share()

        return CartOutput(
            cart: cart,
            cartTotal: cart.map(cartTotal()),
            cartEmpty: cart.map(cartEmpty()),
            checkoutVisible: cart.map(checkoutVisible())
                .startWith((visible: false, animated: false)))
    }
```

The cell is then passed a reference to these subject backed observers, and can then bind the tap events from the custom controls to the observers.

```swift
final class CartCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!

    private(set) var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}

extension CartCell {
    func bind(viewModel: CartCellViewModel, incrementObserver: AnyObserver<CartProduct>, decrementObserver: AnyObserver<CartProduct>) {
        thumbImageView.image = viewModel.image
        nameLabel.text = viewModel.name
        priceLabel.text = viewModel.price
        countLabel.text = viewModel.count

        rx.incrementTap
            .map { viewModel.product }
            .bind(to: incrementObserver)
            .disposed(by: disposeBag)

        rx.decrementTap
            .map { viewModel.product }
            .bind(to: decrementObserver)
            .disposed(by: disposeBag)
    }
}

extension Reactive where Base: CartCell {
    var incrementTap: ControlEvent<Void> { base.plusButton.rx.tap }
    var decrementTap: ControlEvent<Void> { base.minusButton.rx.tap }
}
```

This demo uses RxDataSources to animate the changes 😎.
