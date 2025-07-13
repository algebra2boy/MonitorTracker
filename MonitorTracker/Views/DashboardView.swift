//
//  DashboardView.swift
//  MonitorTracker
//
//  Created by Yongye Tan on 7/12/25.
//

import SwiftUI
import FamilyControls
import DeviceActivity

struct DashboardView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var familyActivitySelection: FamilyActivitySelection
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                // just screen time for today
                DeviceActivityReport(
                    DeviceActivityReport.Context(rawValue: "Total Activity"),
                    filter: DeviceActivityFilter(
                        segment: .daily(during: Calendar.current.dateInterval(of: .day, for: .now)!),
                        users: .all,
                        devices: .all,
                        applications: familyActivitySelection.applicationTokens,
                        categories: familyActivitySelection.categoryTokens,
                        webDomains: familyActivitySelection.webDomainTokens
                    )
                )
            }
            
            .padding()
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Return")
                    }
                }
            }
        }
    }
    
}

#Preview {
    DashboardView(familyActivitySelection: .constant(.init()))
}
