//
//  CardsListView.swift
//  WheresApp
//
//  Created by macuser on 28/5/2023.
//

import SwiftUI
import CoreData
import LocalAuthentication

struct CardsListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)],
        predicate: NSPredicate(format: "nature == 'Credit Card'"),
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    @State private var searchText = ""
    @State private var authenticated = false

    private let numberFormatter: NumberFormatter = {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.generatesDecimalNumbers = true
                return formatter
            }()
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // Check whether it's possible to use biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {

            // Handle events
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This is a security check reason.") { success, authenticationError in
                
                if success {
                    authenticated = true
                } else {
                    authenticated = false
                }
            }
        } else {
            print("Cannot eval policy")
            authenticated = false
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    if (item.nature == "Credit Card" && authenticated == true) {
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
                                        Text("Credit Card")
                                    }
                                }
                                
                                Section(header: Text("Credit Card No")) {
                                    label: do {
                                        Text(item.credit_card_no!)
                                    }
                                    
                                }
                                
                                
                                Section(header: Text("Credit Card Name")) {
                                    label: do {
                                        Text(item.credit_card_name!)
                                    }
                                    
                                }
                                
                                Section(header: Text("Credit Card Expiry Date")) {
                                    label: do {
                                       Text(item.credit_card_expiry_date!)
                                    }
                                }
                                
                                
                                Section(header: Text("Location")) {
                                    label: do {
                                        Text(item.loc_string!)
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
                                Text(item.credit_card_name!)
                                Text(item.credit_card_no!)
                                Text(item.credit_card_expiry_date!)
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
                items.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "(credit_card_name CONTAINS[cd] %@) OR (credit_card_no CONTAINS[cd] %@)", newValue, newValue)
            }
            else {
                items.nsPredicate = newValue.isEmpty ? nil : NSPredicate()
            }
        }
        .onAppear() {
            print("Authenticating...")
            authenticate()
        }
        .onDisappear() {
            authenticated = false
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
