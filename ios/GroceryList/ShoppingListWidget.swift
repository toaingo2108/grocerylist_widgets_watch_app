//
//  ShoppingListWidget.swift
//  GroceryListExtension
//
//  Created by Mobile World on 1/25/24.
//

import SwiftUI
import WidgetKit

struct ShoppingListProvider: AppIntentTimelineProvider {
    typealias Entry = ShoppingListEntry
    typealias Intent = BackgroundIntent
    
    func snapshot(for configuration: BackgroundIntent, in context: Context) async -> ShoppingListEntry {
        let prefs = UserDefaults(suiteName: "group.jack.grocerylist.groceryList")
        // Load the current Count
        let entry = ShoppingListEntry(date: Date(), count: prefs?.integer(forKey: "counter") ?? 0, page: prefs?.integer(forKey: "page") ?? 0, method: configuration.method)
        
        return entry
    }
    
    func timeline(for configuration: BackgroundIntent, in context: Context) async -> Timeline<ShoppingListEntry> {
        let entry = await snapshot(for: configuration, in: context)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        return timeline
    }
    
  func placeholder(in context: Context) -> ShoppingListEntry {
      ShoppingListEntry(date: Date(), count: 0, page: 0, method: .increment)
  }

  func getSnapshot(in context: Context, completion: @escaping (ShoppingListEntry) -> Void) {
    // Get the UserDefaults for the AppGroup
    let prefs = UserDefaults(suiteName: "group.jack.grocerylist.groceryList")
    // Load the current Count
      let entry = ShoppingListEntry(date: Date(), count: prefs?.integer(forKey: "counter") ?? 0, page: prefs?.integer(forKey: "page") ?? 0, method: WidgetMethod(rawValue: prefs?.string(forKey: "method") ?? "increment") ?? .increment)
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
    let count: Int
    let page: Int
    let method: WidgetMethod
}

struct ShoppingListViewEntryView: View {
  var entry: ShoppingListProvider.Entry
//    var intent: ShoppingListProvider.Intent

  @Environment(\.widgetFamily) var family

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
        VStack {
            Text("Shopping List").font(.caption2).frame(
                maxWidth: .infinity, alignment: .center)
            Spacer()
            HStack {
                Text(entry.count.description).font(.title).frame(maxWidth: .infinity, alignment: .center)
                Spacer()
                Text(entry.method.localizedStringResource.key).font(.title).frame(maxWidth: .infinity, alignment: .center)
            }
            Spacer()
            HStack {
                // This button is for clearing
                Button(intent: BackgroundIntent(method: .toggle) ) {
                    Image(systemName: "xmark").font(.system(size: 16)).foregroundColor(.red).frame(
                        width: 24, height: 24)
                }.buttonStyle(.plain).frame(alignment: .leading)
                
                Spacer()
                Button(intent: BackgroundIntent(method: entry.method)) {
                    Image(systemName: "arrow.right").font(.system(size: 16)).foregroundColor(.white)
                    
                }.frame(width: 24, height: 24)
                    .background(.blue)
                    .cornerRadius(12).frame(alignment: .trailing)
                Spacer()
                // This button is for incrementing
                Button(intent: BackgroundIntent(method: .increment)) {
                    Image(systemName: "plus").font(.system(size: 16)).foregroundColor(.white)
                    
                }.frame(width: 24, height: 24)
                    .background(.blue)
                    .cornerRadius(12).frame(alignment: .trailing)
            }
        }
    }
  }
}

struct ShoppingListWidget: Widget {
  let kind: String = "ShoppingListWidget"

  var body: some WidgetConfiguration {
      AppIntentConfiguration(kind: kind, intent: BackgroundIntent.self, provider: ShoppingListProvider()) {
          ShoppingListViewEntryView(entry: $0)
      }
      .configurationDisplayName("Grocery List Widget")
      .description("Configure Grocery List Widget Select Method")
      .supportedFamilies([.systemSmall])
//    StaticConfiguration(kind: kind, provider: ShoppingListProvider()) { entry in
//      if #available(iOS 17.0, *) {
//        ShoppingListViewEntryView(entry: entry)
//          .containerBackground(.fill.tertiary, for: .widget)
//      } else {
//        ShoppingListViewEntryView(entry: entry)
//          .padding()
//          .background()
//      }
//    }
    .configurationDisplayName("Shipping List Widget")
    .description("Shopping List Items")
    .supportedFamilies([
      .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge, .accessoryCircular,
    ])
  }
}

#Preview(as: .systemSmall){
    ShoppingListWidget()
} timeline: {
    ShoppingListEntry(date: .now, count: 0, page: 0, method: .increment)
}

