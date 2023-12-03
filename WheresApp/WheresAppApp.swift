//
//  WheresAppApp.swift
//  WheresApp
//
//  Created by macuser on 16/3/2023.
//

import SwiftUI

@main
struct WheresAppApp: App {
    @StateObject private var viewRouter = ViewRouter()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewRouter)
        }
    }
}
