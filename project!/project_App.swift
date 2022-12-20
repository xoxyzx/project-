//
//  project_App.swift
//  project!
//
//  Created by 許雯淇 on 2022/12/19.
//

import SwiftUI

@main
struct project_App: App {
    @StateObject private var loginData = Login()
    var body: some Scene {
        WindowGroup {
            if loginData.token == ""
            {
                SignInView().environmentObject(loginData)
            }else{
                ContentView().environmentObject(loginData)
            }
        }
    }
}
