# Monitor Tracker

Monitor Tracker is an iOS application that utilizes Apple's Device Activity Monitoring capabilities to help users track and report screen time for selected apps and categories.

## Key Frameworks and APIs

- **FamilyControls**: Used to present the Family Activity Picker, allowing users to select which apps and categories to monitor.
- **DeviceActivity**: Used to monitor device activity, schedule monitoring intervals, and generate activity reports.
- **SwiftUI**: Used for building the app's user interface.

## How Selection is Stored

The app uses `UserDefaults` to persist the user's app and category selections across launches. The selection is represented by the [`FamilyActivitySelection`](https://developer.apple.com/documentation/familycontrols/familyactivityselection) object. When the user updates their selection, it is encoded using `JSONEncoder` and saved to `UserDefaults`. On app launch, the selection is loaded and decoded using `JSONDecoder`.

Relevant code can be found in [`MonitoringViewModel`](MonitorTracker/ViewModel/MonitorViewModel.swift)

## What is `FamilyActivitySelection`?

[`FamilyActivitySelection`](https://developer.apple.com/documentation/familycontrols/familyactivityselection) is a type provided by the FamilyControls framework. It represents the user's selection of apps, categories, and web domains to monitor. In this app, it is used to configure which activities are tracked and reported.

## What is `DeviceActivityReport`?

[`DeviceActivityReport`](https://developer.apple.com/documentation/deviceactivity/deviceactivityreport) is a SwiftUI view provided by the DeviceActivity framework. It displays a report of device activity based on the selected context and filter. In this app, it is used in the dashboard to show the user's screen time for the selected apps and categories.

Example usage in [`DashboardView`](MonitorTracker/Views/DashboardView.swift):

```swift
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
```

## Project Structure

- **MonitorTracker/**: Main app code, including views and view models.
- **DeviceActivityMonitorExtension/**: Extension for monitoring device activity.
- **DeviceActivityReporterExtension/**: Extension for reporting device activity.

## Getting Started

1. Open the project in Xcode.
2. Build and run on a device (Device Activity APIs require a real device).
3. Grant Family Controls permission when prompted.
4. Select apps and categories to monitor.
5. View your screen time dashboard.
