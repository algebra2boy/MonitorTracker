//
//  DeviceActivityReporterExtension.swift
//  DeviceActivityReporterExtension
//
//  Created by Yongye Tan on 7/13/25.
//

import DeviceActivity
import SwiftUI

@main
struct DeviceActivityReporterExtension: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
