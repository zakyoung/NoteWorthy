//
//  NoteWorthy.swift
//  finalProject
//
//  Created by Zak Young on 3/11/24.
//

import SwiftUI

@main
struct NoteWorthy: App {
    @StateObject var appHandler = AppHandler()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appHandler)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)){ _ in
                    appHandler.currentNoteSaving()
                    appHandler.saveNotes()
                    appHandler.saveSubjects()
                    appHandler.saveToolBar()
                }
        }
    }
}

