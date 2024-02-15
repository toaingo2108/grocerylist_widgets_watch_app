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
    
    @Parameter(title: "Item" )
    var item: String

  public init() {
      method = .increment
      item = ""
  }

    init(method: WidgetMethod, item: String) {
        self.method = method
        self.item = item
    }

  public func perform() async throws -> some IntentResult {
      print(self.item)
      
      if method == .increment {
          print("groceryList://increment-\(item)")
          await HomeWidgetBackgroundWorker.run(
            url: URL(string: "groceryList://increment-\(item.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
            appGroup: "group.jack.grocerylist.groceryList")
      }
      else {
          await HomeWidgetBackgroundWorker.run(
            url: URL(string: "groceryList://toggle-\(item.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"),
            appGroup: "group.jack.grocerylist.groceryList")
      }
    return .result()
  }
    
    public static var parameterSummary: some ParameterSummary {
        Summary {
            \.$method
        }
    }
}

/// This is required if you want to have the widget be interactive even when the app is fully suspended.
/// Note that this will launch your App so on the Flutter side you should check for the current Lifecycle State before doing heavy tasks
@available(iOS 17, *)
@available(iOSApplicationExtension, unavailable)
extension BackgroundIntent: ForegroundContinuableIntent {}

