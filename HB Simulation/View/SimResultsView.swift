//
//  SimResultView.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 4/7/24.
//

import SwiftUI

struct SimResultsView: View {
    @State var isResultsReady: Bool = true
    @State var isSimulationStarted: Bool = false
    var body: some View {
        if !isSimulationStarted {
            if isResultsReady {
                NavigationStack {
                    ScrollView {
                        resultCard(title: "Q1", descriptions: ["something"], results: ["0%"])
                    }
                    .padding(.horizontal, 12)
                    .navigationTitle("Results")
                }
            } else {
                VStack {
                    Spacer()
                    Spacer()
                    Text("Welcome to Hubble and Baker simulator")
                        .multilineTextAlignment(.center)
                        .font(.title)
                    Spacer()
                    Button {
                    } label: {
                        Text("Start Simulation")
                            .frame(width: 275, height: 50, alignment: .center)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(Color.white)
                            .background(Color.accentColor)
                            .cornerRadius(25)
                    }
                    Spacer()
                }
            }
        } else {
            VStack {
                Text("Simulation is running")
                    .font(.title)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
    }
}

#Preview {
    SimResultsView()
}
