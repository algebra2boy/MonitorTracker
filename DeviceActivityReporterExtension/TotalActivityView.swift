//
//  TotalActivityView.swift
//  DeviceActivityReporterExtension
//
//  Created by Yongye Tan on 7/13/25.
//

import SwiftUI
import DeviceActivity

// [DeviceActivityData] -> [ActivitySegment] -> [CategoryActivity] -> [ApplicationActivity]
struct TotalActivityView: View {
    
    let results: [DeviceActivityData]
    
    @State private var activitySegments: [DeviceActivityData.ActivitySegment] = []
    
    var body: some View {
        NavigationStack {
            List(results, id: \.hashValue) { result in
                Section {
                    ForEach(activitySegments, id: \.hashValue) { segment in
                        NavigationLink(String(describing: segment.hashValue)) {
                            ActivitySegmentView(activitySegment: segment)
                        }
                    }
                }
            }
        }
        .task {
            var activitySegments: [DeviceActivityData.ActivitySegment] = []
            for result in results {
                for await segment in result.activitySegments {
                    activitySegments.append(segment)
                }
            }
            self.activitySegments = activitySegments
        }
    }
}

extension TotalActivityView {
    
    struct ActivitySegmentView: View {
        
        let activitySegment: DeviceActivityData.ActivitySegment
        
        @State private var categories: [DeviceActivityData.CategoryActivity] = []
        
        var body: some View {
            List {
                ForEach(categories, id: \.hashValue) { category in
                    NavigationLink(category.category.localizedDisplayName ?? "N/A") {
                        ActicityCategoryView(category: category)
                    }
                }
            }
            .task {
                var categories: [DeviceActivityData.CategoryActivity] = []
                for await category in activitySegment.categories {
                    categories.append(category)
                }
                self.categories = categories
            }
        }
    }
}

extension TotalActivityView {
    
    struct ActicityCategoryView: View {
        
        let category: DeviceActivityData.CategoryActivity
        
        @State private var applications: [DeviceActivityData.ApplicationActivity] = []
        
        var body: some View {
            List {
                if let categoryName = category.category.localizedDisplayName {
                    LabeledContent("Category") {
                        Text(categoryName)
                    }
                }
                
                LabeledContent("Screen Time") {
                    Text(category.totalActivityDuration.convertDoubleToHoursMinutes())
                }
                
                Section {
                    ForEach(applications, id: \.hashValue) { application in
                        NavigationLink(application.application.localizedDisplayName ?? "N/A") {
                            ApplicationView(application: application)
                        }
                    }
                } header: {
                    Text("Applications")
                }
            }
            .task {
                var applications: [DeviceActivityData.ApplicationActivity] = []
                for await application in category.applications {
                    applications.append(application)
                }
                self.applications = applications
            }
        }
        
    }
    
}

extension TotalActivityView {
    
    struct ApplicationView: View {
        
        let application: DeviceActivityData.ApplicationActivity
        
        var body: some View {
            List {
                Section {
                    LabeledContent("Screen Time") {
                        Text(application.totalActivityDuration.convertDoubleToHoursMinutes())
                    }
                    
                    if let applicationName = application.application.localizedDisplayName {
                        LabeledContent("Application") {
                            Text(applicationName)
                        }
                    }
                }
                
            }
            
        }
    }
    
}

extension Double {
    func convertDoubleToHoursMinutes() -> String {
        let totalSeconds = Int(self)
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}
