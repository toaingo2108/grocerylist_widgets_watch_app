//
//  ContentView.swift
//  GroceryList Watch App
//
//  Created by Mobile World on 1/25/24.
//

import SwiftUI

// Your JSON string as a Swift constant
let defaultDataStr = """
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
  ]
}
"""

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

func loadShoppingData() -> [ShoppingItem]? {
    let jsonString = UserDefaults(suiteName: "group.jack.grocerylist.groceryList")?.string(forKey: "list") ?? defaultDataStr
    var items: [ShoppingItem] = []
    if let jsonData = jsonString.data(using: .utf8) {
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
    return nil
}

// SwiftUI View
struct ShoppingListView: View {
    @State var items: [ShoppingItem] = [
        ShoppingItem(color: .yellow, title: "My Shopping List", count: 0),
        ShoppingItem(color: .orange, title: "Walmart", count: 0),
        ShoppingItem(color: .blue, title: "Kroger", count: 0)
    ]

    init() {
        if let loadedData = loadShoppingData() {
            items = loadedData
        }
    }
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink(destination: ShoppingDetailsView(shop: item.title)) {
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
            .navigationTitle("Shopping List")
            .onAppear {
                if let loadedData = loadShoppingData() {
                    items = loadedData
                }
            }
        }
    }
}

// Preview provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
