//
//  ZeusModeView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 26/12/2024.
//

import SwiftUI

struct ZeusModeView: View {
    @AppStorage("zeusOnboarding") var onboardingFinished = false
    @StateObject var zeusModel = ZeusDocument()
    var body: some View {
        if onboardingFinished {
            ZeusMainView(zeus: zeusModel)
                .navigationTitle("Zeus")
                .navigationBarTitleDisplayMode(.inline)
        } else {
            ZeusOnboardingView()
                .navigationTitle("Zeus onboarding")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ZeusModeView()
}
