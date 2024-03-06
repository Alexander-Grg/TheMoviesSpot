//
//  MainTabbedView.swift
//  TheMoviesSpot
//
//  Created by Alexander Grigoryev on 2024-03-05.
//

import SwiftUI

struct MainTabbedView: View {
    var body: some View {
        ZStack {
            TabView {
                EmptyView()
                    .tabItem {
                        Label("Main", systemImage: "house")
                    }
                EmptyView()
                    .tabItem { Label("List", systemImage: "list.clipboard") }
                
                EmptyView()
                    .tabItem { Label("Menu", systemImage: "menubar.arrow.down.rectangle") }
            }
        }
    }
}

#Preview {
    MainTabbedView()
}
