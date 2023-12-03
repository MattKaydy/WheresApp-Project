//
//  ViewRouter.swift
//  WheresApp
//
//  Created by macuser on 23/3/2023.
//

import Foundation

enum AppView {
    case add, item, search, receipt
}

class ViewRouter: ObservableObject {
    // here you can decide which view to show at launch
    @Published var currentView: AppView = .item
}
