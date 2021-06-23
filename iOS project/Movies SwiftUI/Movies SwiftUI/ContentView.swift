//
//  ContentView.swift
//  Movies SwiftUI
//
//  Created by Hal Mueller on 6/22/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("The First Tab")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
        }
        .font(.headline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
