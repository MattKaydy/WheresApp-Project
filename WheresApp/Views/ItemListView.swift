//
//  ItemListView.swift
//  WheresApp
//
//  Created by macuser on 16/3/2023.
//

import SwiftUI
import CoreData

struct ItemListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    @State private var searchText = ""
    @State var mode: String
    
    private let numberFormatter: NumberFormatter = {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.generatesDecimalNumbers = true
                return formatter
            }()
    
    func getTotalExpenditure() -> Float {
        var sum: Float = 0
        for item in items {
            if (item.nature == "Receipts") {
                sum += item.receipt_grand_total
            }
            
        }
        return sum
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    if (item.nature == "General") {
                        NavigationLink {
                                Form {
                                Section(header: Text("")) {
                                    label: do {
                                        if (item.image_data != nil) {
                                            Image(uiImage: UIImage(data: item.image_data!)!)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 143, height: 200)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                    }
                                }
                
                                Section(header: Text("Catagory")) {
                                    label: do {
                                        Text("General")
                                    }
                                }
                                
                                Section(header: Text("Item Name")) {
                                    label: do {
                                        Text(item.name!)
                                    }
                                }
                                
                                
                                Section(header: Text("Type")) {
                                    label: do {
                                        Text(item.type!)
                                    }
                                    
                                }

                                
                                Section(header: Text("Location")) {
                                    label: do {
                                        Text(item.loc_string!)
                                    }
                                }
                                
                                Section(header: Text("Keywords")) {
                                    //                        TextField("Keywords", text: $keywordsText)
                                    //                            .disabled(true)
                                    List(item.keywords!, id: \.self) { keyword in
                                        Text(keyword)
                                    }
                                    
                                }
                            }
                            
                        } label: {
                            VStack{
                                Image(uiImage: UIImage(data: item.image_data!)!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 143, height: 200)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                Text(item.name!)
                                Text(item.type!)
                                Text(item.loc_string!)
                            }
                            
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            Text("Select an item")
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { newValue in
            if searchText != "" {
                items.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "(name CONTAINS[cd] %@) OR (type CONTAINS[cd] %@) OR (keywords_string CONTAINS[cd] %@)", newValue, newValue, newValue)
            }
            else {
                items.nsPredicate = newValue.isEmpty ? nil : NSPredicate()
            }
        }
    }
    
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.name = "New Item"

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

