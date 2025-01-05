//
//  ZeusInputConfigView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 28/12/2024.
//

import SwiftUI

struct ZeusInputConfigView: View {
    @AppStorage(GlobalConstants.StorageKeys.Zeus.username) var zeusUsername = "" {
        didSet {
            ZeusConfig.sharedInstance.username = zeusUsername
        }
    }
    @AppStorage(GlobalConstants.StorageKeys.Zeus.tab) var zeusTabApiKey = "" {
        didSet {
            ZeusConfig.sharedInstance.tabToken = zeusTabApiKey
        }
    }
    @AppStorage(GlobalConstants.StorageKeys.Zeus.door) var zeusDoorAccessApiKey = "" {
        didSet {
            ZeusConfig.sharedInstance.doorToken = zeusDoorAccessApiKey
        }
    }

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
