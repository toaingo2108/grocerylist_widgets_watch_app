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
enum WidgetMethod: String, AppEnum {
    case increment
    case toggle

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "increment")

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .increment: .init(title: "Increment"),
        .toggle: .init(title: "Toggle")
    ]
}

@available(iOS 17, *)
public struct BackgroundIntent: WidgetConfigurationIntent {

  static public var title: LocalizedStringResource = "Increment Counter"

    @Parameter(title: "Method", default: WidgetMethod.increment)
    var method: WidgetMethod

  public init() {
      method = .increment
  }

   init(method: WidgetMethod) {
    self.method = method
  }

  public func perform() async throws -> some IntentResult {
      print(method.localizedStringResource.key)
    await HomeWidgetBackgroundWorker.run(
        url: URL(string: "groceryList://\(method.localizedStringResource.key)"),
      appGroup: "group.jack.grocerylist.groceryList")

    return .result()
  }
}

/// This is required if you want to have the widget be interactive even when the app is fully suspended.
/// Note that this will launch your App so on the Flutter side you should check for the current Lifecycle State before doing heavy tasks
@available(iOS 17, *)
@available(iOSApplicationExtension, unavailable)
extension BackgroundIntent: ForegroundContinuableIntent {}

