//
//  MonitorViewModel.swift
//  MonitorTracker
//
//  Created by Yongye Tan on 7/13/25.
//

import SwiftUI
import FamilyControls
import DeviceActivity

@Observable class MonitoringViewModel {
    
    private static let selectionKey = "familyActivitySelection"
    
    var selection: FamilyActivitySelection {
        didSet { // every time selection changed, save the selection locally
            saveSelection()
        }
    }
    
    init() {
        self.selection = Self.loadSelection()
    }
    
    /// loads the ``FamilyActivitySelection`` locally using userDefaults
    private static func loadSelection() -> FamilyActivitySelection {
        guard let data = UserDefaults.standard.data(forKey: selectionKey) else {
            return FamilyActivitySelection()
        }
        
        do {
            return try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        } catch {
            print("Failed to save selection \(error)")
            return FamilyActivitySelection()
        }
        
    }
    
    /// saves the ``FamilyActivitySelection`` locally using userDefaults
    private func saveSelection() {
        do {
            let data = try JSONEncoder().encode(selection)
            UserDefaults.standard.set(data, forKey: Self.selectionKey)
        } catch {
            print("Failed to save selection: \(error)")
        }
    }
}
