//
//  ZeusOnboardingView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 26/12/2024.
//

import SwiftUI

struct ZeusOnboardingView: View {
    @AppStorage(GlobalConstants.StorageKeys.Zeus.onboarding) var onboardingFinished = false
    @AppStorage(GlobalConstants.StorageKeys.Zeus.username) var zeusUsername = ""
    @AppStorage(GlobalConstants.StorageKeys.Zeus.tab) var zeusTabApiKey = ""
    @AppStorage(GlobalConstants.StorageKeys.Zeus.tap) var zeusTapApiKey = ""
    @AppStorage(GlobalConstants.StorageKeys.Zeus.door) var zeusDoorAccessApiKey = ""

    var body: some View {
        VStack {
            Form {
                Section("Username") {
                    TextField(
                        "Required",
                        text: $zeusUsername
                    )
                    .textInputAutocapitalization(.never)
                }

                Section("API Key voor Tab") {
                    TextField(
                        "Required",
                        text: $zeusTabApiKey
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                }

                Section("API Key voor Tap") {
                    TextField(
                        "Required",
                        text: $zeusTapApiKey
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                }

                Section("API Key voor door access") {
                    TextField(
                        "Optional",
                        text: $zeusDoorAccessApiKey
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                }
            }
            Button(
                action: {
                    onboardingFinished = true
                },
                label: {
                    HStack {
                        Spacer()
                        Label("Finish", systemImage: "checkmark")
                        Spacer()
                    }
                    .padding(.vertical, 7)
                }
            )
            .buttonStyle(.borderedProminent)
            .frame(width: .infinity)
            .padding()
        }
        .background(Color(.secondarySystemBackground))
    }
}

#Preview {
    ZeusOnboardingView()
}
