//
//  TotalActivityView.swift
//  DeviceActivityReporterExtension
//
//  Created by Yongye Tan on 7/13/25.
//

import SwiftUI
import DeviceActivity

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
        .ignoresSafeArea()
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
                
                LabeledContent("Total Activity Duration") {
                    Text(String(describing: category.totalActivityDuration))
                }
                
                Section {
                    ForEach(applications, id: \.hashValue) { application in
                        NavigationLink(application.application.localizedDisplayName ?? "(N/A)") {
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
                    LabeledContent("Total Activity Duration") {
                        Text(String(describing: application.totalActivityDuration))
                    }
                    
                    if let applicationName = application.application.localizedDisplayName {
                        LabeledContent("application") {
                            Text(applicationName)
                        }
                    }
                }
                
            }
            
        }
    }
    
}
