//
//  TabBarView.swift
//  MatchApp
//
//  Created by Kerem on 14.12.2024.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedTab = 0

    var body: some View {

        TabView(selection: $selectedTab) {
            HomeView()
                .environmentObject(SportManager())
                .environmentObject(HistoryManager())
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            HistoryView()
                .environmentObject(SportManager())
                .environmentObject(HistoryManager())
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
                .tag(1)
        }

    }
}

#Preview {
    TabBarView()
        .environmentObject(SportManager())
        .environmentObject(HistoryManager())
}
