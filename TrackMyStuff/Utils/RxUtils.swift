//
// Copyright (c) 2017 GirAppe Studio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Observable {
    static func deferredJust(_ element: E) -> Observable<E> {
        return Observable.deferred({ () -> Observable<E> in
            return Observable<E>.just(element)
        })
    }

    func asVoid() -> Observable<Void> {
        return self.map { _ in }
    }
}

extension ObservableType {
    public func observeOnMain() -> Observable<Self.E> {
        return observeOn(MainScheduler.instance)
    }

    public func debugSubscribe() -> Disposable {
        return self.subscribe(onNext: { value in
            print("RxDEBUG - next value: \(value)")
        }, onError: { error in
            print("RxDEBUG - error: \(error)")
        }, onCompleted: { _ in
            print("RxDEBUG - completed")
        }, onDisposed: { _ in
            print("RxDEBUG - disposed")
        })
    }
}

infix operator >>>: AdditionPrecedence
func >>> (lhs: Disposable?, rhs: DisposeBag) {
    lhs?.disposed(by: rhs)
}

infix operator ~>: AdditionPrecedence
func ~> <L, R>(lhs: Observable<L>, rhs: Observable<R>) -> Observable<R> {
    return lhs.flatMap({ _ -> Observable<R> in
        return rhs
    })
}

infix operator -->: AdditionPrecedence
func --> <T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable {
    return property.bind(to: variable)
}
func --> <T>(observable: Observable<T>, variable: Variable<T>) -> Disposable {
    return observable.bind(to: variable)
}
func --> <T>(variable1: Variable<T>, variable2: Variable<T>) -> Disposable {
    return variable1.asObservable().bind(to: variable2)
}

public protocol Optionable {
    associatedtype WrappedType
    func unwrap() -> WrappedType
    func isEmpty() -> Bool
}

extension Optional : Optionable {
    public typealias WrappedType = Wrapped
    public func unwrap() -> WrappedType {
        return self!
    }
    public func isEmpty() -> Bool {
        return self == nil
    }
}

extension ObservableType where E : Optionable {
    public func unwrap() -> Observable<E.WrappedType> {
        return self.filter({ !$0.isEmpty() }).map({ $0.unwrap() })
    }
}

extension ObservableType where E: Collection {
    public func toSequence() -> Observable<E.Iterator.Element> {
        return self.flatMap({ array -> Observable<E.Iterator.Element> in
            return Observable.create({ observer -> Disposable in
                for element in array {
                    observer.onNext(element)
                }
                observer.onCompleted()
                return Disposables.create()
            })
        })
    }
}

