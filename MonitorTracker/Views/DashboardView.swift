//
//  DashboardView.swift
//  MonitorTracker
//
//  Created by Yongye Tan on 7/12/25.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, Dashboard")
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DashboardView()
}
