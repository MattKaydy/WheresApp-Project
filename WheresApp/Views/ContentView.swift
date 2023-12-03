//
//  ContentView.swift
//  WheresApp
//
//  Created by macuser on 16/3/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var viewRouter: ViewRouter

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var selectedTab = 1;
   

    var body: some View {
        TabView (selection: $viewRouter.currentView) {
            
            TaskAddView(receipt_location: "", receipt_time: "", receipt_name: "", receipt_item_names: [], receipt_item_prices: [], receipt_grand_total: 0, keywords: [], name: "", nature: "", type: "", loc_langtitude: "", loc_longtitude: "", loc_string: "", credit_card_no: "", credit_card_expiry_date: "", credit_card_name: "", keywords_string: "")
                .environmentObject(viewRouter)
                .tabItem {
                    Image(systemName: "plus")
                    Text("Add Item")
                }
                .tag(AppView.add)
            
            ItemListView(mode: "General")
                .tabItem {
                    Image(systemName: "square.text.square")
                    Text("Items")
                    
                }
                .tag(AppView.item)
            
            CardsListView()
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Cards")
                }
                .tag(AppView.search)
            
            ReceiptsListView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard.fill")
                    Text("Receipts")
                }
                .tag(AppView.receipt)
            
        }

        
    }

    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
