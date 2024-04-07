//
//  SimSettingsView.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 4/7/24.
//

import SwiftUI

struct SimSettingsView: View {
    @StateObject var viewModel = SimSettingsModelView()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $viewModel.isSection2) {
                        Text("Section 2")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SimSettingsView()
}
