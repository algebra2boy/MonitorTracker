//
//  ScreenTimeSelectionAppView.swift
//  MonitorTracker
//
//  Created by Yongye Tan on 7/12/25.
//

import SwiftUI
import FamilyControls
import DeviceActivity
import ManagedSettings

struct ScreenTimeSelectionAppView: View {
    
    @State private var familyActivityPickerPresented: Bool = false
    @State var monitorViewModel = MonitoringViewModel()
    @State private var authorizationStatus: AuthorizationStatus = .notDetermined
    @State private var dashBoardPresented: Bool = false
    @State private var center: DeviceActivityCenter = .init()
    
    var body: some View {
        
        NavigationStack {
            
            VStack(spacing: 20) {
                
                if authorizationStatus == .approved {
                    
                    appSelectionView
                    
                    List {
                        
                        Section {
                            
                            ForEach(Array(monitorViewModel.selection.categories), id: \.hashValue) { category in
                                if let token = category.token {
                                    Label(token)
                                }
                                if let localizedDisplayName = category.localizedDisplayName {
                                    Text(localizedDisplayName)
                                }
                            }
                        } header: {
                            if monitorViewModel.selection.categories.count > 0 {
                                Text("Tracked Categories: \(monitorViewModel.selection.categories.count) in total")
                            }
                        }
                        
                        Section {
                            
                            ForEach(Array(monitorViewModel.selection.applications), id: \.hashValue) { application in
                                if let token = application.token {
                                    Label(token)
                                }
                                
                                if let localizedDisplayName = application.localizedDisplayName {
                                    Text(localizedDisplayName)
                                }
                            }
                        } header: {
                            if monitorViewModel.selection.applications.count > 0 {
                                Text("Tracked Applications: \(monitorViewModel.selection.applications.count) in total")
                            }
                        }
                    }
                    .scrollContentBackground(.hidden) // hide default background
                    
                    Button {
                        // disable this function for since we just want to report screen time not triggering even
                        // startMonitoring()
                        dashBoardPresented.toggle()
                    } label: {
                        Text("Start Monitoring")
                    }
//                    .disabled(monitorViewModel.selection.applications.isEmpty && monitorViewModel.selection.categoryTokens.isEmpty)
                    
//                    Button {
//                        dashBoardPresented.toggle()
//                    } label: {
//                        Text("Check Dashboard")
//                    }
                    
                } else {
                    
                    requestAccessView
                    
                }
            }
            .navigationTitle("App Selection")
            .onAppear(perform: updateAuthorizationStatus)
        }
    }
    
    var appSelectionView: some View {
        Button {
            familyActivityPickerPresented.toggle()
        } label: {
            Text("Select Apps")
                .font(.headline)
        }
        .familyActivityPicker(
            isPresented: $familyActivityPickerPresented,
            selection: $monitorViewModel.selection)
        .sheet(isPresented: $dashBoardPresented) {
            DashboardView(familyActivitySelection: $monitorViewModel.selection)
        }
    }
    
    var requestAccessView: some View {
        VStack(spacing: 20) {
            
            Text("Family Controls Access Required")
                .font(.headline)
            
            Text("This app needs access to Family Controls to help you monitor and manage screen time for selected apps.")
                .multilineTextAlignment(.leading)
            
            Button(action: requestAuthorization) {
                Text("Grant Permission")
                    .font(.headline)
            }
            
        }
        .padding()
    }
    
    /// Stretch Feature: trigger an event at a threshold
    /// from now until 1 hour from now (threshold at 50th minute)
    private func startMonitoring() {
        
        // Schedules monitoring from now to 1 hour
        let start = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: .now)
        let end = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: .now.addingTimeInterval(60 * 60))
        let threshold = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: .now.addingTimeInterval(50 * 60))
        
        let schedule = DeviceActivitySchedule(
            intervalStart: start,
            intervalEnd: end,
            repeats: true
        )
        
        do {
            try center.startMonitoring(
                .init("DailyMonitor"),
                during: schedule,
                events: [
                    .init("MyUsageLimit"): DeviceActivityEvent(
                        applications: monitorViewModel.selection.applicationTokens,
                        categories: monitorViewModel.selection.categoryTokens,
                        webDomains: monitorViewModel.selection.webDomainTokens,
                        threshold: threshold // triggers an event if the total usage excceds the threshold
                    )
                ]
            )
            print("I have started monitoring")
        } catch {
            print("failed to start monitoring: \(error)")
        }
        
    }
    
    private func updateAuthorizationStatus() {
        authorizationStatus = AuthorizationCenter.shared.authorizationStatus
    }
    
    
    private func requestAuthorization() {
        
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                updateAuthorizationStatus()
                
            } catch {
                print("having some permission error", error)
                updateAuthorizationStatus()
            }
        }
    }
    
}

#Preview {
    ScreenTimeSelectionAppView()
}
