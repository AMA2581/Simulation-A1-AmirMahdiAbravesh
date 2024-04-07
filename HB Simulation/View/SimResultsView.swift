//
//  SimResultView.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 4/7/24.
//

import SwiftUI

struct SimResultsView: View {
    @StateObject var viewModel = SimResultsModelView()

    var body: some View {
        if !viewModel.isSimulationStarted {
            if viewModel.isResultsReady {
                NavigationStack {
                    ScrollView {
                        resultCard(title: "Start Status",
                                   descriptions: ["Section", 
                                                  "Customer count"],
                                   results: [HB_SimulationApp.simEventMain.isSection2 ? "2" : "1",
                                             "\(HB_SimulationApp.simEventMain.initCustomerCount)"])
                        resultCard(title: "Q1",
                                   descriptions: ["average wait time",
                                                  "average service time"],
                                   results: [HB_SimulationApp.simEventMain.averageWaitTimePrint(),
                                             HB_SimulationApp.simEventMain.averageServiceTimePrint()])
                        resultCard(title: "Q2",
                                   descriptions: ["hubble utilization",
                                                  "baker utilization",
                                                  "total utilization"],
                                   results: [HB_SimulationApp.simEventMain.utilizationPrintH(),
                                             HB_SimulationApp.simEventMain.utilizationPrintB(),
                                             HB_SimulationApp.simEventMain.utilizationPrintTotal()])
                        resultCard(title: "Q3",
                                   descriptions: ["average people in queue"],
                                   results: [HB_SimulationApp.simEventMain.averagePeopleInQueuePerClockPrint()])
                        resultCard(title: "Q4",
                                   descriptions: ["baker probablity"],
                                   results: [HB_SimulationApp.simEventMain.bakerProbPrint()])
                        resultCard(title: "Q5",
                                   descriptions: ["hubble customer rate",
                                                  "baker customer rate"],
                                   results: [HB_SimulationApp.simEventMain.customerUtilPrintH(),
                                             HB_SimulationApp.simEventMain.customerUtilPrintB()])
                        resultCard(title: "Q9",
                                   descriptions: ["hubble salary",
                                                  "baker salary"],
                                   results: [HB_SimulationApp.simEventMain.salaryPrintH(),
                                             HB_SimulationApp.simEventMain.salaryPrintB()])
                        resultCard(title: "Q10",
                                   descriptions: ["number of traffics"],
                                   results: [HB_SimulationApp.simEventMain.trafficCountPrint()])
                        resultCard(title: "Q11",
                                   descriptions: ["baker finishing first"],
                                   results: [HB_SimulationApp.simEventMain.syncServicesPrint()])
                        Button {
                            viewModel.resetSimulation()
                        } label: {
                            Text("Reset")
                                .frame(width: 275, height: 50, alignment: .center)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.white)
                                .background(Color.accentColor)
                                .cornerRadius(25)
                        }
                        .padding(.vertical, 20)
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
                        viewModel.startSimulation()
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
