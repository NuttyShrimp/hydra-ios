//
//  ZeusInputConfigView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 28/12/2024.
//

import SwiftUI

struct ZeusInputConfigView: View {
    @AppStorage(GlobalConstants.StorageKeys.Zeus.username) var zeusUsername = ""
    @AppStorage(GlobalConstants.StorageKeys.Zeus.tab) var zeusTabApiKey = ""
    @AppStorage(GlobalConstants.StorageKeys.Zeus.door) var zeusDoorAccessApiKey = ""

    var body: some View {
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

            Section("API Key voor door access") {
                TextField(
                    "Optional",
                    text: $zeusDoorAccessApiKey
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            }
        }
    }
}

#Preview {
    ZeusInputConfigView()
}
