//
//  ShoppingDetailsWidget.swift
//  GroceryListExtension
//
//  Created by Mobile World on 1/25/24.
//

import SwiftUI
import WidgetKit

struct ShoppingDetailsProvider: AppIntentTimelineProvider {
    typealias Entry = ShoppingDetailsEntry
    typealias Intent = BackgroundIntent
    
    func snapshot(for configuration: BackgroundIntent, in context: Context) async -> ShoppingDetailsEntry {
        let prefs = UserDefaults(suiteName: "group.jack.grocerylist.groceryList")
        // Load the current Count
        let entry = ShoppingDetailsEntry(date: Date(), count: prefs?.integer(forKey: "counter") ?? 0, shoppingDetailsStr: prefs?.string(forKey: "list") ?? "[]", method: configuration.method)
        
        return entry
    }
    
    func timeline(for configuration: BackgroundIntent, in context: Context) async -> Timeline<ShoppingDetailsEntry> {
        let entry = await snapshot(for: configuration, in: context)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        return timeline
    }
    
  func placeholder(in context: Context) -> ShoppingDetailsEntry {
      ShoppingDetailsEntry(date: Date(), count: 0, shoppingDetailsStr: "[]", method: .increment)
  }

  func getSnapshot(in context: Context, completion: @escaping (ShoppingDetailsEntry) -> Void) {
    // Get the UserDefaults for the AppGroup
    let prefs = UserDefaults(suiteName: "group.jack.grocerylist.groceryList")
    // Load the current Count
      let entry = ShoppingDetailsEntry(date: Date(), count: prefs?.integer(forKey: "counter") ?? 0, shoppingDetailsStr: prefs?.string(forKey: "list") ?? "[]", method: WidgetMethod(rawValue: prefs?.string(forKey: "method") ?? "increment") ?? .increment)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    getSnapshot(in: context) { (entry) in
      let timeline = Timeline(entries: [entry], policy: .atEnd)
      completion(timeline)
    }
  }
}

struct ShoppingDetailsEntry: TimelineEntry {
    let date: Date
    let count: Int
    let shoppingDetailsStr: String
    let method: WidgetMethod
}

struct ShoppingItemDetails: Identifiable {
    let id = UUID()
    let name: String
    let isChecked: Bool
    let quantity: Int
    let icon: Image?
}

struct ShoppingDetailsViewEntryView: View {
  var entry: ShoppingDetailsProvider.Entry
  let data = UserDefaults.init(suiteName: "group.jack.grocerylist.groceryList")
    
    var shoppingItems: [String: [ShoppingItemDetails]]
    
    init(entry: ShoppingDetailsProvider.Entry) {
        self.entry = entry
        entry.shoppingDetailsStr
        
        var items: [String: [ShoppingItemDetails]] = [:]

        items["Vegetables"] = [
            ShoppingItemDetails(name: "Basil", isChecked: false, quantity: 1, icon: Image("basil")),
//            ShoppingItemDetails(name: "Basil", isChecked: false, quantity: 1, icon: Image(uiImage: UIImage(contentsOfFile: data?.string(forKey: "basil") ?? "") ?? UIImage())),
            ShoppingItemDetails(name: "Tomatoes", isChecked: true, quantity: 1, icon: Image("tomatoes"))
        ]

        items["Cereal & Breakfast Foods"] = [
            ShoppingItemDetails(name: "Cheerios", isChecked: false, quantity: 1, icon: Image("cheerios")),
            ShoppingItemDetails(name: "Corn Flakes", isChecked: false, quantity: 1, icon: Image( "corn_flakes")),
            ShoppingItemDetails(name: "Cream Of Wheat", isChecked: true, quantity: 1, icon: Image( "cream_of_wheat"))
        ]

        // Add other categories and items as needed

        shoppingItems = items
    }
  var body: some View {
    ForEach(shoppingItems.keys.sorted(), id: \.self) { key in
        Section(header: Text(key).font(.headline).foregroundColor(.yellow).padding(.top, 10).padding(.bottom, 5)) {
            ForEach(shoppingItems[key]!) { item in
                Button (intent: BackgroundIntent(method: entry.method)) {
                    HStack {
                        Button(intent: BackgroundIntent(method: .toggle)) {
                            Image(systemName: item.isChecked ? "checkmark.square" : "square")
                                .foregroundColor(item.isChecked ? .green : .gray)
                        }.buttonStyle(BorderlessButtonStyle()).padding(.trailing, 8)
                        
                        if(item.icon != nil) {
                            item.icon!
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding(.trailing, 8)
                        }
                        else {
                            Text("image is nil")
                        }
                        
                        Text(item.name)
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("\(item.quantity)")
                            .foregroundColor(.white)
                            .font(.system(size: 10))
                            .padding([.trailing, .leading], 8)
                            .padding([.top, .bottom], 4)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
        }
        
    
//        VStack {
//            Text("Shopping List").font(.caption2).frame(
//                maxWidth: .infinity, alignment: .center)
//            Spacer()
//            HStack {
//                Text(entry.count.description).font(.title).frame(maxWidth: .infinity, alignment: .center)
//                Spacer()
//                Text(entry.method.localizedStringResource.key).font(.title).frame(maxWidth: .infinity, alignment: .center)
//            }
//            Spacer()
//            HStack {
//                // This button is for clearing
//                Button(intent: BackgroundIntent(method: .toggle) ) {
//                    Image(systemName: "xmark").font(.system(size: 16)).foregroundColor(.red).frame(
//                        width: 24, height: 24)
//                }.buttonStyle(.plain).frame(alignment: .leading)
//
//                Spacer()
//                Button(intent: BackgroundIntent(method: entry.method)) {
//                    Image(systemName: "arrow.right").font(.system(size: 16)).foregroundColor(.white)
//
//                }.frame(width: 24, height: 24)
//                    .background(.blue)
//                    .cornerRadius(12).frame(alignment: .trailing)
//                Spacer()
//                // This button is for incrementing
//                Button(intent: BackgroundIntent(method: .increment)) {
//                    Image(systemName: "plus").font(.system(size: 16)).foregroundColor(.white)
//
//                }.frame(width: 24, height: 24)
//                    .background(.blue)
//                    .cornerRadius(12).frame(alignment: .trailing)
//            }
//        }
        }
    }
}


struct ShoppingDetailsWidget: Widget {
  let kind: String = "ShoppingDetailsWidget"

  var body: some WidgetConfiguration {
      AppIntentConfiguration(kind: kind, intent: BackgroundIntent.self, provider: ShoppingDetailsProvider()) {
          ShoppingDetailsViewEntryView(entry: $0)
              .containerBackground(for: .widget) {
              Color(red: 36/255.0, green: 37/255.0, blue: 42/255.0)
          }
      }
      .configurationDisplayName("Grocery Details Widget")
      .description("Configure Grocery Details Widget Select Method")
      .supportedFamilies([.systemLarge, .systemExtraLarge])
//    StaticConfiguration(kind: kind, provider: ShoppingDetailsProvider()) { entry in
//      if #available(iOS 17.0, *) {
//        ShoppingDetailsViewEntryView(entry: entry)
//          .containerBackground(.fill.tertiary, for: .widget)
//      } else {
//        ShoppingDetailsViewEntryView(entry: entry)
//          .padding()
//          .background()
//      }
//    }
//    .configurationDisplayName("Shipping List Widget")
//    .description("Shopping List Items")
//    .supportedFamilies([
//      .systemSmall, .systemMedium, .systemLarge, .systemExtraLarge, .accessoryCircular,
//    ])
  }
}

#Preview(as: .systemSmall){
    ShoppingDetailsWidget()
} timeline: {
    ShoppingDetailsEntry(date: .now, count: 0, shoppingDetailsStr:  "[]", method: .increment)
}


