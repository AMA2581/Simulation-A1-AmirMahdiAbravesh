//
//  ContentView.swift
//  HB Simulation
//
//  Created by Amir Mahdi Abravesh on 4/7/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SimResultsView()
                .tabItem {
                    Label("Results", systemImage: "server.rack")
                }
            SimSettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
