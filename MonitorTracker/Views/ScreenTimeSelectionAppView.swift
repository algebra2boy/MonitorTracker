//
//  ScreenTimeSelectionAppView.swift
//  MonitorTracker
//
//  Created by Yongye Tan on 7/12/25.
//

import SwiftUI
import FamilyControls
import DeviceActivity

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
                    
                    Button {
                        startMonitoring()
                        dashBoardPresented.toggle()
                    } label: {
                        Text("Start Monitoring")
                    }
                    .disabled(monitorViewModel.selection.applications.isEmpty && monitorViewModel.selection.categoryTokens.isEmpty)
                    
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
    
    private func startMonitoring() {
        
        // Schedules monitoring from now to 24 hours later.
        let start = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: .now)
        let end = Calendar.current.dateComponents([.month, .day, .hour, .minute], from: .now.addingTimeInterval(60 * 60 * 24))
        
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
                        threshold: DateComponents(hour: 1) // triggers an event if usage exceeds 1 hour (for now, we can ignore this)
                    )
                ]
            )
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
