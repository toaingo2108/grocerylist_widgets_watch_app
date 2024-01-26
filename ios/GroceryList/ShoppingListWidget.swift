//
//  ShoppingListWidget.swift
//  GroceryListExtension
//
//  Created by Mobile World on 1/25/24.
//

import SwiftUI
import WidgetKit
import AppIntents

struct ShoppingListProvider: TimelineProvider {
    
    static let defaultDataString = """
{
  "My Shopping List": [],
  "Walmart": [],
  "Kroger": [],
}
"""
    func snapshot(for configuration: BackgroundIntent, in context: Context) async -> ShoppingListEntry {
        let prefs = UserDefaults(suiteName: "group.jack.grocerylist.groceryList")
        // Load the current Count
        let entry = ShoppingListEntry(date: Date(), shoppingListStr: prefs?.string(forKey: "list") ?? ShoppingListProvider.defaultDataString, method: configuration.method)
                
        return entry
    }
    
    func timeline(for configuration: BackgroundIntent, in context: Context) async -> Timeline<ShoppingListEntry> {
        let entry = await snapshot(for: configuration, in: context)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        return timeline
    }
    
  func placeholder(in context: Context) -> ShoppingListEntry {
      ShoppingListEntry(date: Date(), shoppingListStr: ShoppingListProvider.defaultDataString, method: .increment)
  }

  func getSnapshot(in context: Context, completion: @escaping (ShoppingListEntry) -> Void) {
    // Get the UserDefaults for the AppGroup
    let prefs = UserDefaults(suiteName: "group.jack.grocerylist.groceryList")
    // Load the current Count
      let entry = ShoppingListEntry(date: Date(), shoppingListStr: prefs?.string(forKey: "list") ?? "[]", method: WidgetMethod(rawValue: prefs?.string(forKey: "method") ?? "increment") ?? .increment)
      
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    getSnapshot(in: context) { (entry) in
      let timeline = Timeline(entries: [entry], policy: .atEnd)
      completion(timeline)
    }
  }
}

struct ShoppingListEntry: TimelineEntry {
    let date: Date
    let shoppingListStr: String
    let method: WidgetMethod
}

struct ShoppingItem: Identifiable {
    let id = UUID()
    let color: Color
    let title: String
    var count: Int
    
    // Computed property to get the initials for the icon
    var initials: String {
        return title.components(separatedBy: " ")
            .reduce("") { ($0 == "" ? "" : "\($0.first!)") + "\($1.first!)" }
    }
    
    // Computed property to determine the number of dots to display
    var countIndicator: Int {
        min(count, 3) // For example, display up to 3 dots
    }
}

struct ShoppingListViewEntryView: View {
  var entry: ShoppingListProvider.Entry

  @Environment(\.widgetFamily) var family

    var items: [ShoppingItem] = [
        ShoppingItem(color: .yellow, title: "My Shopping List", count: 0),
        ShoppingItem(color: .orange, title: "Walmart", count: 0),
        ShoppingItem(color: .blue, title: "Kroger", count: 0)
    ]
    
    init(entry: ShoppingListProvider.Entry) {
        self.entry = entry
                
        if let jsonData = entry.shoppingListStr.data(using: .utf8) {
            do {
                if let shoppingList = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    for index in items.indices {
                        let shop = items[index]
                        let categories = shoppingList[shop.title] as? [[String:Any]]
                        var count = 0
                        for category in categories ?? [] {
                            let detailItems = category["items"] as? [[String:Any]]
                            for item in detailItems ?? [] {
                                if item["isChecked"] as? Bool ?? false {
                                    count += item["quantity"] as? Int ?? 0
                                }
                            }
                        }
                        items[index].count = count
                    }
                }
                    
            }
            catch {
                print(error)
            }
        }
        
        print(items)
    }
    
  var body: some View {
    if family == .accessoryCircular {
      Image(
        uiImage: UIImage(
          contentsOfFile: UserDefaults(suiteName: "group.jack.grocerylist.groceryList")?.string(
            forKey: "dash_counter") ?? "")!
      ).resizable()
        .frame(width: 76, height: 76)
        .scaledToFill()
    } else {
        ForEach(items) { item in
            HStack {
                Circle()
                    .fill(item.color)
                    .frame(width: 40, height: 40)
                    .overlay(Text(item.initials).foregroundColor(.white))
                
                Text(item.title)
                    .padding(.leading, 8).foregroundColor(.white)
                
                Spacer()
                
                Text("\(item.count)").foregroundStyle(.white)
            }
        }
    }
    }
}


struct ShoppingListWidget: Widget {
  let kind: String = "ShoppingListWidget"

  var body: some WidgetConfiguration {
      StaticConfiguration(kind: kind, provider: ShoppingListProvider()) {
          ShoppingListViewEntryView(entry: $0).containerBackground(for: .widget) {
              Color(red: 36/255.0, green: 37/255.0, blue: 42/255.0)
          }
      }
      .configurationDisplayName("Grocery List Widget")
      .description("Configure Grocery List Widget Select Method")
      .supportedFamilies([.systemSmall, .systemMedium])
  }
}

#Preview(as: .systemSmall){
    ShoppingListWidget()
} timeline: {
    ShoppingListEntry(date: .now, shoppingListStr:  ShoppingListProvider.defaultDataString, method: .increment)
}

