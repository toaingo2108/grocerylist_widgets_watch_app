//
//  ShoppingListWidget.swift
//  GroceryListExtension
//
//  Created by Mobile World on 1/25/24.
//

import SwiftUI
import WidgetKit

struct ShoppingListProvider: TimelineProvider {
  func placeholder(in context: Context) -> ShoppingListEntry {
      ShoppingListEntry(date: Date(), count: 0, page: 0)
  }

  func getSnapshot(in context: Context, completion: @escaping (ShoppingListEntry) -> Void) {
    // Get the UserDefaults for the AppGroup
    let prefs = UserDefaults(suiteName: "group.es.antonborri.homeWidgetCounter")
    // Load the current Count
    let entry = ShoppingListEntry(date: Date(), count: prefs?.integer(forKey: "counter") ?? 0, page: prefs?.integer(forKey: "page") ?? 0)
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
}

struct ShoppingListViewEntryView: View {
  var entry: ShoppingListProvider.Entry

  @Environment(\.widgetFamily) var family

  var body: some View {
    if family == .accessoryCircular {
      Image(
        uiImage: UIImage(
          contentsOfFile: UserDefaults(suiteName: "group.es.antonborri.homeWidgetCounter")?.string(
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
                Text(entry.page.description).font(.title).frame(maxWidth: .infinity, alignment: .center)
            }
            Spacer()
            HStack {
                // This button is for clearing
                Button(intent: BackgroundIntent(method: "clear")) {
                    Image(systemName: "xmark").font(.system(size: 16)).foregroundColor(.red).frame(
                        width: 24, height: 24)
                }.buttonStyle(.plain).frame(alignment: .leading)
                
                Spacer()
                Button(intent: BackgroundIntent(method: "next_page")) {
                    Image(systemName: "arrow.right").font(.system(size: 16)).foregroundColor(.white)
                    
                }.frame(width: 24, height: 24)
                    .background(.blue)
                    .cornerRadius(12).frame(alignment: .trailing)
                Spacer()
                // This button is for incrementing
                Button(intent: BackgroundIntent(method: "increment")) {
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
    StaticConfiguration(kind: kind, provider: ShoppingListProvider()) { entry in
      if #available(iOS 17.0, *) {
        ShoppingListViewEntryView(entry: entry)
          .containerBackground(.fill.tertiary, for: .widget)
      } else {
        ShoppingListViewEntryView(entry: entry)
          .padding()
          .background()
      }
    }
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
  ShoppingListEntry(date: .now, count: 0, page: 0)
}
