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
    static let defaultDetailStr = """
      {
           "My Shopping List": [
             {
               "category": "Vegetables",
               "items": [
                 {
                   "name": "Basil",
                   "isChecked": false,
                   "quantity": 0,
                   "iconName": "basil"
                 },
                 {
                   "name": "Tomatoes",
                   "isChecked": false,
                   "quantity": 0,
                   "iconName": "tomatoes"
                 }
               ]
             },
             {
               "category": "Cereal & Breakfast Foods",
               "items": [
                 {
                   "name": "Cheerios",
                   "isChecked": false,
                   "quantity": 0,
                   "iconName": "cheerios"
                 },
                 {
                   "name": "Corn Flakes",
                   "isChecked": false,
                   "quantity": 0,
                   "iconName": "corn_flakes"
                 },
                 {
                   "name": "Cream Of Wheat",
                   "isChecked": false,
                   "quantity": 0,
                   "iconName": "cream_of_wheat"
                 }
               ]
             }
           ],
        }
"""
    
    func snapshot(for configuration: BackgroundIntent, in context: Context) async -> ShoppingDetailsEntry {
        let prefs = UserDefaults(suiteName: "group.jack.grocerylist.groceryList")
        // Load the current Count
        let entry = ShoppingDetailsEntry(date: Date(), shop: prefs?.string(forKey: "shop") ?? "My Shopping List", shoppingDetailsStr: prefs?.string(forKey: "list") ?? ShoppingDetailsProvider.defaultDetailStr, method: configuration.method)
        
        return entry
    }
    
    func timeline(for configuration: BackgroundIntent, in context: Context) async -> Timeline<ShoppingDetailsEntry> {
        let entry = await snapshot(for: configuration, in: context)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        return timeline
    }
        
  func placeholder(in context: Context) -> ShoppingDetailsEntry {
      ShoppingDetailsEntry(date: Date(), shop: "My Shopping List", shoppingDetailsStr: ShoppingDetailsProvider.defaultDetailStr, method: .increment)
  }

  func getSnapshot(in context: Context, completion: @escaping (ShoppingDetailsEntry) -> Void) {
    // Get the UserDefaults for the AppGroup
    let prefs = UserDefaults(suiteName: "group.jack.grocerylist.groceryList")
    // Load the current Count
      let entry = ShoppingDetailsEntry(date: Date(), shop: prefs?.string(forKey: "shop") ?? "My Shopping List", shoppingDetailsStr: prefs?.string(forKey: "list") ?? "[]", method: WidgetMethod(rawValue: prefs?.string(forKey: "method") ?? "increment") ?? .increment)
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
    let shop: String
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
  }
}

#Preview(as: .systemSmall){
    ShoppingDetailsWidget()
} timeline: {
    ShoppingDetailsEntry(date: .now, shop: "My Shopping List", shoppingDetailsStr:  ShoppingDetailsProvider.defaultDetailStr, method: .increment)
}


