//
//  ReceiptsListView.swift
//  WheresApp
//
//  Created by macuser on 29/5/2023.
//

import SwiftUI
import CoreData

struct ReceiptsListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        predicate: NSPredicate(format: "nature == 'Receipts'"),
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    //@State private var sum:Float = 0
    @State private var searchText = ""

    private let numberFormatter: NumberFormatter = {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.generatesDecimalNumbers = true
                return formatter
            }()
    
    func getTotalExpenditure() -> Float {
        var acc: Float = 0
        for item in items {
            if (item.nature == "Receipts") {
                acc += item.receipt_grand_total
            }
            
        }
        return acc
    }
    
    var body: some View {
        
        
        NavigationView {
            List {
                Section(header: Text("Total:")) {
                    label: do {
                        Text(String(getTotalExpenditure()))
                    }
                }
                ForEach(items) { item in
                    if (item.nature == "Receipts") {
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
                                
                                Section(header: Text("Store Name")) {
                                    label: do {
                                       Text(item.receipt_name!)
                                    }
                                }
                                
                                Section(header: Text("Time")) {
                                    label: do {
                                       Text(item.receipt_time!)
                                    }
                                }
                                
                                Section(header: Text("Location")) {
                                    label: do {
                                       Text(item.receipt_location!)
                                    }
                                }
                                
                                Section(header: Text("Items")) {
                                    List(item.receipt_item_names!, id: \.self) { item in
                                        Text(item)
                                    }
                                }
                                
                                Section(header: Text("Grand Total")) {
                                    label: do {
                                       Text(String(item.receipt_grand_total))
                                    }
                                }
                                
                                
                            }
                            
                        } label: {
                            VStack{
                                Text(item.receipt_name!)
                                Text("Total: $" + String(item.receipt_grand_total))
                                Text(item.receipt_time!)
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
                print(newValue)
                items.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "(receipt_name CONTAINS[cd] %@) OR (receipt_location CONTAINS[cd] %@)", newValue, newValue)
            }
            else {
                items.nsPredicate = newValue.isEmpty ? nil : NSPredicate()
            }
        }
        .onAppear() {
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
