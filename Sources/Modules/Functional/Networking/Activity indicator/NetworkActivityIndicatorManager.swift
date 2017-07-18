//
//  Created by Michal Matuszczyk
//  Copyright © 2017 Michal Matuszczyk. All rights reserved.
//

import Foundation
import UIKit

// Shamelessly stolen from: https://github.com/Alamofire/AlamofireNetworkActivityIndicator
public class NetworkActivityIndicatorManager {
  private enum ActivityIndicatorState {
    case notActive, delayingStart, active, delayingCompletion
  }

// MARK: - Singleton

  public static let shared = NetworkActivityIndicatorManager()

// MARK: - Properties

  /// A boolean value indicating whether the network activity indicator is currently visible.
  public private(set) var isNetworkActivityIndicatorVisible: Bool = false {
    didSet {
      guard isNetworkActivityIndicatorVisible != oldValue else { return }

      DispatchQueue.main.async {
        UIApplication.shared.isNetworkActivityIndicatorVisible = self.isNetworkActivityIndicatorVisible
      }
    }
  }

  /// A time interval indicating the minimum duration of networking activity that should occur before the activity
  /// indicator is displayed. Defaults to `1.0` second.
  public var startDelay: TimeInterval = 1.0

  /// A time interval indicating the duration of time that no networking activity should be observed before dismissing
  /// the activity indicator. This allows the activity indicator to be continuously displayed between multiple network
  /// requests. Without this delay, the activity indicator tends to flicker. Defaults to `0.2` seconds.
  public var completionDelay: TimeInterval = 0.2

  private var activityIndicatorState: ActivityIndicatorState = .notActive {
    didSet {
      switch activityIndicatorState {
      case .notActive:
        isNetworkActivityIndicatorVisible = false
        invalidateStartDelayTimer()
        invalidateCompletionDelayTimer()
      case .delayingStart:
        scheduleStartDelayTimer()
      case .active:
        invalidateCompletionDelayTimer()
        isNetworkActivityIndicatorVisible = true
      case .delayingCompletion:
        scheduleCompletionDelayTimer()
      }
    }
  }

  private var activityCount: Int = 0

  private var startDelayTimer: Timer?
  private var completionDelayTimer: Timer?

  private let lock = NSLock()

// MARK: - Internal - Initialization

  private init() { }

  deinit {
    invalidateStartDelayTimer()
    invalidateCompletionDelayTimer()
  }

// MARK: - Activity Count

  /// Increments the number of active network requests.
  ///
  /// If this number was zero before incrementing, the network activity indicator will start spinning after
  /// the `startDelay`.
  ///
  /// Generally, this method should not need to be used directly.
  public func incrementActivityCount() {
    lock.lock() ; defer { lock.unlock() }

    activityCount += 1
    updateActivityIndicatorStateForNetworkActivityChange()
  }

  /// Decrements the number of active network requests.
  ///
  /// If the number of active requests is zero after calling this method, the network activity indicator will stop
  /// spinning after the `completionDelay`.
  ///
  /// Generally, this method should not need to be used directly.
  public func decrementActivityCount() {
    lock.lock() ; defer { lock.unlock() }

    activityCount -= 1
    updateActivityIndicatorStateForNetworkActivityChange()
  }

// MARK: - Private - Activity Indicator State

  private func updateActivityIndicatorStateForNetworkActivityChange() {
    switch activityIndicatorState {
    case .notActive:
      if activityCount > 0 { activityIndicatorState = .delayingStart }
    case .delayingStart:
      // No-op - let the delay timer finish
      break
    case .active:
      if activityCount == 0 { activityIndicatorState = .delayingCompletion }
    case .delayingCompletion:
      if activityCount > 0 { activityIndicatorState = .active }
    }
  }

// MARK: - Private - Timers

  private func scheduleStartDelayTimer() {
    let timer = Timer(
      timeInterval: startDelay,
      target: self,
      selector: #selector(NetworkActivityIndicatorManager.startDelayTimerFired),
      userInfo: nil,
      repeats: false
    )

    DispatchQueue.main.async {
      RunLoop.main.add(timer, forMode: .commonModes)
      RunLoop.main.add(timer, forMode: .UITrackingRunLoopMode)
    }

    startDelayTimer = timer
  }

  private func scheduleCompletionDelayTimer() {
    let timer = Timer(
      timeInterval: completionDelay,
      target: self,
      selector: #selector(NetworkActivityIndicatorManager.completionDelayTimerFired),
      userInfo: nil,
      repeats: false
    )

    DispatchQueue.main.async {
      RunLoop.main.add(timer, forMode: .commonModes)
      RunLoop.main.add(timer, forMode: .UITrackingRunLoopMode)
    }

    completionDelayTimer = timer
  }

  @objc private func startDelayTimerFired() {
    lock.lock() ; defer { lock.unlock() }

    if activityCount > 0 {
      activityIndicatorState = .active
    } else {
      activityIndicatorState = .notActive
    }
  }

  @objc private func completionDelayTimerFired() {
    lock.lock() ; defer { lock.unlock() }
    activityIndicatorState = .notActive
  }

  private func invalidateStartDelayTimer() {
    startDelayTimer?.invalidate()
    startDelayTimer = nil
  }

  private func invalidateCompletionDelayTimer() {
    completionDelayTimer?.invalidate()
    completionDelayTimer = nil
  }
}
