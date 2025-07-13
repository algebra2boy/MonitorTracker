//
//  DashboardView.swift
//  MonitorTracker
//
//  Created by Yongye Tan on 7/12/25.
//

import SwiftUI
import FamilyControls
import DeviceActivity
import DeviceActivityMonitorTracker

struct DashboardView: View {
    
    let familyActivitySelection: FamilyActivitySelection
    
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                DeviceActivityReport(
                    DeviceActivityReport.Context(rawValue: "DeviceReportActivity"), // the context of your extension
                    filter: DeviceActivityFilter(
                        segment: .hourly(during: DateInterval(start: Date(timeIntervalSinceNow: 60 * 60 * 24), end: Date())),
                        users: .all,
                        devices: .init([.iPhone]),
                        applications: familyActivitySelection.applicationTokens,
                        categories: familyActivitySelection.categoryTokens,
                        webDomains: familyActivitySelection.webDomainTokens
                    )
                )
            }
            
            .padding()
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

#Preview {
    DashboardView(familyActivitySelection: .init())
}
