//
//  SimSettingsView.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 4/7/24.
//

import SwiftUI

struct SimSettingsView: View {
    @StateObject var viewModel = SimSettingsModelView()
    @FocusState var NCFocusState: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $viewModel.isSection2) {
                        Text("Section 2")
                    }
                    HStack() {
                        TextField("Number of Customers", text: $viewModel.initCustomerCountString)
                            .keyboardType(.numberPad)
                            .focused($NCFocusState)
                        Button {
                            NCFocusState = false
                        } label: {
                            Text("Submit")
                        }
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
