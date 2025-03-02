//
//  ZeusInputConfigView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 28/12/2024.
//

import SwiftUI

struct ZeusInputConfigView: View {
    @State var zeusUsername = ZeusConfig.sharedInstance.username ?? ""
    @State var zeusTabApiKey = ZeusConfig.sharedInstance.tabToken ?? ""
    @State var zeusTapApiKey = ZeusConfig.sharedInstance.tapToken ?? ""
    @State var zeusDoorAccessApiKey = ZeusConfig.sharedInstance.doorToken ?? ""
    
    var body: some View {
        Form {
            Section("Username") {
                TextField(
                    "Required",
                    text: $zeusUsername
                )
                .onChange(of: zeusUsername) { newValue in
                    ZeusConfig.sharedInstance.username = newValue
                }
                .textInputAutocapitalization(.never)
            }

            Section("API Key voor Tab") {
                TextField(
                    "Required",
                    text: $zeusTabApiKey
                )
                .onChange(of: zeusTabApiKey) { newValue in
                    ZeusConfig.sharedInstance.tabToken = newValue
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            }
            
            Section("API Key voor Tap") {
                TextField(
                    "Required",
                    text: $zeusTapApiKey
                )
                .onChange(of: zeusTapApiKey) { newValue in
                    ZeusConfig.sharedInstance.tapToken = newValue
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            }
            
            Section("API Key voor door access") {
                TextField(
                    "Optional",
                    text: $zeusDoorAccessApiKey
                )
                .onChange(of: zeusDoorAccessApiKey) { newValue in
                    ZeusConfig.sharedInstance.doorToken = newValue
                }
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            }
        }
    }
}

#Preview {
    ZeusInputConfigView()
}
