//
//  DashboardView.swift
//  MonitorTracker
//
//  Created by Yongye Tan on 7/12/25.
//

import SwiftUI
import FamilyControls

struct DashboardView: View {
    @State private var usageData: [AppUsageData] = []
        
    var body: some View {
        NavigationStack {
            VStack {
                
                if usageData.isEmpty {
                    emptyStateView
                } else {
                    summaryView
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: loadUsageData)
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 20) {
            
            Text("No Usage Data")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Usage data will appear here once you start using the selected apps")
                .font(.body)
        }
    }
    
    var summaryView: some View {
        Section {
            usageListView
        } header: {
            HStack {
                Text("Application Usage")
                    .font(.title2)
                Spacer()
            }
            
        }
    }
    
    var usageListView: some View {
        ForEach(usageData, id: \.self) { data in
            AppUsageRow(appData: data)
        }
    }
    
    private func loadUsageData() {
        usageData = [
            AppUsageData(appName: "Safari", usageMinutes: 45, icon: "globe"),
            AppUsageData(appName: "Messages", usageMinutes: 30, icon: "message"),
            AppUsageData(appName: "Mail", usageMinutes: 15, icon: "envelope"),
            AppUsageData(appName: "Photos", usageMinutes: 10, icon: "photo")
        ]
        
    }
}

struct AppUsageRow: View {
    
    let appData: AppUsageData
    
    var body: some View {
        HStack {
            Image(systemName: appData.icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(appData.appName)
                    .font(.headline)
                
                Text("\(appData.usageMinutes) minutes")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
    
}

struct AppUsageData: Hashable {
    let appName: String
    let usageMinutes: Int
    let icon: String
    
    init(appName: String, usageMinutes: Int, icon: String) {
        self.appName = appName
        self.usageMinutes = usageMinutes
        self.icon = icon
    }
}

#Preview {
    DashboardView()
}
