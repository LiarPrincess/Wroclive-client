// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
// If a copy of the MPL was not distributed with this file,
// You can obtain one at http://mozilla.org/MPL/2.0/.

import ReSwift
import RxSwift

// Created by Vincenzo Scamporlino on 2016-11-04.
// Source: https://github.com/vinzscam/ReSwift-Rx/blob/master/Sources/Store%2BRx.swift

extension ReSwift.Store: ReactiveCompatible { }

extension Reactive where Base: ReSwift.StoreType {

  var state: Observable<Base.State> {
    return Observable.create { observer in
      let storeSubscriber = RxStoreSubscriber<Base.State>(observer: observer)

      self.base.subscribe(storeSubscriber)
      return Disposables.create { self.base.unsubscribe(storeSubscriber) }
    }
  }
}

private class RxStoreSubscriber<State>: StoreSubscriber {
  typealias StoreSubscriberStateType = State

  private let observer: AnyObserver<State>

  init(observer: AnyObserver<State>) {
    self.observer = observer
  }

  func newState(state: State) {
    self.observer.onNext(state)
  }
}
