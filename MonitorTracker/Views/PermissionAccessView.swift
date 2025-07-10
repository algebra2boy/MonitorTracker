//
//  PermissionAccessView.swift
//  MonitorTracker
//
//  Created by Yongye Tan on 7/9/25.
//

import SwiftUI
import FamilyControls

struct PermissionAccessView: View {
    var body: some View {
        VStack {
            
            Text("We need access to your Screen Time data to monitor app usage.")
            
            Button("Accept") {
                Task {
                    do {
                        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
                    } catch {
                        print("having some permission error", error)
                    }
                }
            }
            
        }
        
    }
}

#Preview {
    VStack {
        PermissionAccessView()
    }
    .padding()
}
