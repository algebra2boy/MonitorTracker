//
//  ScreenTimeSelectionAppView.swift
//  MonitorTracker
//
//  Created by Yongye Tan on 7/12/25.
//

import SwiftUI
import FamilyControls

struct ScreenTimeSelectionAppView: View {
    
    @State private var familyActivityPickerPresented: Bool = false
    @State private var familyActivitySelection: FamilyActivitySelection = .init()
    @State private var authorizationStatus: AuthorizationStatus = .notDetermined
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                if authorizationStatus == .approved {
                    
                    Button {
                        
                    } label: {
                        Text("Select Apps")
                            .font(.headline)
                    }
                    .familyActivityPicker(
                        isPresented: $familyActivityPickerPresented,
                        selection: $familyActivitySelection)
                    
                } else {
                    
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
            }
            .navigationTitle("App Selection")
            .onAppear(perform: updateAuthorizationStatus)
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
