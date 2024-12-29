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
    @AppStorage(GlobalConstants.StorageKeys.Zeus.enabled) var zeusMode = false
    @AppStorage(GlobalConstants.StorageKeys.preferredResto) private var preferredResto = ""
    @AppStorage(GlobalConstants.StorageKeys.allergens) private var showAllergens: Bool = false {
        didSet {
            UserDefaults.standard.synchronize()
        }
    }

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
                    Toggle(
                        isOn: $showAllergens
                    ) {
                        Text("Toon allergenen")
                        Text("Toon de allergenen in de menu's van de restaurants.")
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(
                                "Informatie over alleregenen wordt op een best-effort manier voorzien. Fouten zijn dus mogelijk!"
                            )
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
                if zeusMode {
                    NavigationLink(destination: {
                        ZeusInputConfigView()
                    }, label: {
                        Label("Zeus instellingen", systemImage: "key")
                    })
                }
                NavigationLink(destination: {
                    SettingsAboutView()
                }, label: {
                    Label("Over deze app", systemImage: "info.circle")
                })
                #if DEBUG
                    Button(
                        action: {
                            UserDefaults.standard.removeObject(forKey: GlobalConstants.StorageKeys.onboarding)
                        },
                        label: {
                            Label("Reset onboarding", systemImage: "arrow.clockwise")
                        })
                #endif
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
