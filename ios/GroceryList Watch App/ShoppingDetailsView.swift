import SwiftUI

struct ShoppingItemDetails: Identifiable, Decodable {
    let id: UUID
    let name: String
    let isChecked: Bool
    let quantity: Int
    let iconName: String
}

struct ShoppingCategory: Identifiable, Decodable {
    let id: UUID
    let category: String
    let items: [ShoppingItemDetails]
}

struct ShoppingDetailsView: View {
    var categories: [ShoppingCategory] = []
    var shop: String
    
    init(shop: String) {
        self.categories = [ShoppingCategory(id: UUID(), category: "Vegetables", items: [
                            ShoppingItemDetails(id: UUID(), name: "Basil", isChecked: false, quantity: 1, iconName: "basil"),
                            ShoppingItemDetails(id: UUID(), name: "Tomatoes", isChecked: true, quantity: 1, iconName: "tomatoes")
                        ]),
                        ShoppingCategory(id: UUID(), category: "Cereal & Breakfast Foods", items: [
                            ShoppingItemDetails(id: UUID(), name: "Cheerios", isChecked: false, quantity: 1, iconName: "cheerios"),
                            ShoppingItemDetails(id: UUID(), name: "Corn Flakes", isChecked: false, quantity: 1, iconName: "corn_flakes"),
                            ShoppingItemDetails(id: UUID(), name: "Cream Of Wheat", isChecked: true, quantity: 1, iconName: "cream_of_wheat")
                        ])]
        self.shop = shop
    }

    var body: some View {
        List {
            ForEach(categories) { category in
                Section(header: Text(category.category).foregroundColor(.yellow)) {
                    ForEach(category.items) { item in
                        HStack {
                            Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                                .foregroundColor(item.isChecked ? .green : .gray)
                                .onTapGesture {
                                    // Handle the toggle action here
                                }
                            Image(item.iconName) // Assuming the icons are available in the asset catalog
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                            Text(item.name)
                                .foregroundColor(.white)
                                .lineLimit(1)
                            Spacer()
                            Text("\(item.quantity)")
                                .foregroundColor(.white)
                                .padding(5)
                                .background(Color.gray)
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
        .navigationBarTitle(shop)
    }
}

// Sample data for preview
struct ShoppingDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingDetailsView(shop: "My Shopping List")
//        ShoppingDetailsView(categories: [
//            ShoppingCategory(id: UUID(), category: "Vegetables", items: [
//                ShoppingItemDetails(id: UUID(), name: "Basil", isChecked: false, quantity: 1, iconName: "basil"),
//                ShoppingItemDetails(id: UUID(), name: "Tomatoes", isChecked: true, quantity: 1, iconName: "tomatoes")
//            ]),
//            ShoppingCategory(id: UUID(), category: "Cereal & Breakfast Foods", items: [
//                ShoppingItemDetails(id: UUID(), name: "Cheerios", isChecked: false, quantity: 1, iconName: "cheerios"),
//                ShoppingItemDetails(id: UUID(), name: "Corn Flakes", isChecked: false, quantity: 1, iconName: "corn_flakes"),
//                ShoppingItemDetails(id: UUID(), name: "Cream Of Wheat", isChecked: true, quantity: 1, iconName: "cream_of_wheat")
//            ])
//        ])
    }
}
