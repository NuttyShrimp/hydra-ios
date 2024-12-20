//
//  SettingsViews.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var restos: RestoDocument
    @EnvironmentObject var analytics: AnalyticsDocument
    @AppStorage("preferredResto") private var preferredResto = ""

    var body: some View {
        NavigationStack {
            List {
                Section("Restaurant") {
                    Picker("Favoriet", selection: $preferredResto) {
                        ForEach(restos.restoMetas) { resto in
                            Text(resto.name)
                                .tag(resto.endpoint!)
                        }
                    }
                }
                Section("Data gebruik") {
                    Toggle(
                        isOn: $analytics.analyticsEnabled
                    ) {
                        Text("Analytics")
                        Text(
                            "Allow Hydra to collect anonymouse user statistics. We use this to know how many people Hydra & for what they use it."
                        )
                    }
                    Toggle(
                        isOn: $analytics.crashlyticsEnabled
                    ) {
                        Text("Crash reporting")
                        Text(
                            "Send logs and other useful (anonymous) informatie if the app crashes, allowing us to fix the issue as fast as possible."
                        )
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await restos.loadAvailableRestos()
            if preferredResto.isEmpty && restos.restoMetas.count > 0 {
                if let endpoint = restos.restoMetas.first(where: { $0.endpoint != nil })?.endpoint {
                    preferredResto = endpoint
                }
            }
        }
    }
}

#Preview {
    SettingsView(restos: RestoDocument())
        .environmentObject(AnalyticsDocument())
}
