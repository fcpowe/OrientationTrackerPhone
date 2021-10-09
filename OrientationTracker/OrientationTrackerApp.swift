//
//  OrientationTrackerApp.swift
//  OrientationTracker
//
//  Created by Fiona Powers Beggs on 10/8/21.
//

import SwiftUI

@main
struct OrientationTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
