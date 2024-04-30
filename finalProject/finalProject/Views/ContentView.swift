//
//  ContentView.swift
//  finalProject
//
//  Created by Zak Young on 3/10/24.
//

import SwiftUI
import PencilKit
import UIKit
struct ContentView: View {
    @EnvironmentObject var appHandler: AppHandler
    var body: some View {
        Home()
    }
}
#Preview {
    ContentView()
        .environmentObject(AppHandler())
}
