//
//  ZeusInputConfigView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 28/12/2024.
//

import SwiftUI

struct ZeusInputConfigView: View {
    @State var zeusUsername = ZeusConfig.sharedInstance.username ?? "" {
        didSet {
            ZeusConfig.sharedInstance.username = zeusUsername
        }
    }
    @State var zeusTabApiKey = ZeusConfig.sharedInstance.tabToken ?? "" {
        didSet {
            ZeusConfig.sharedInstance.tabToken = zeusTabApiKey
        }
    }
    @State var zeusDoorAccessApiKey = ZeusConfig.sharedInstance.doorToken ?? "" {
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
