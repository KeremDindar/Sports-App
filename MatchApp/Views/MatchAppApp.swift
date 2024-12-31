//
//  MatchAppApp.swift
//  MatchApp
//
//  Created by Kerem on 19.11.2024.
//

import SwiftUI
import Firebase



class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}



@main
struct MatchAppApp: App {
    @StateObject var vm = SportManager()
    @StateObject var historyvm = HistoryManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
           WindowGroup {
               TabView {
                   HomeView()
                       .tabItem {
                           Label("Home", systemImage: "house")
                       }
                   HistoryView()
                       .tabItem {
                           Label("History", systemImage: "clock.arrow.circlepath")
                       }
               }
               .environmentObject(vm)
               .environmentObject(historyvm) 
           }
       }}



