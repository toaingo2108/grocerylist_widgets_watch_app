//
//  BackgroundIntent.swift
//  Runner
//
//  Created by Mobile World on 1/24/24.
//

import AppIntents
import Foundation
import home_widget

@available(iOS 17, *)
public struct BackgroundIntent: AppIntent {
  static public var title: LocalizedStringResource = "Increment Counter"

  @Parameter(title: "Method")
  var method: String

  public init() {
    method = "increment"
  }

  public init(method: String) {
    self.method = method
  }

  public func perform() async throws -> some IntentResult {
    await HomeWidgetBackgroundWorker.run(
      url: URL(string: "groceryList://\(method)"),
      appGroup: "group.jack.grocerylist.groceryList")

    return .result()
  }
}

/// This is required if you want to have the widget be interactive even when the app is fully suspended.
/// Note that this will launch your App so on the Flutter side you should check for the current Lifecycle State before doing heavy tasks
@available(iOS 17, *)
@available(iOSApplicationExtension, unavailable)
extension BackgroundIntent: ForegroundContinuableIntent {}

