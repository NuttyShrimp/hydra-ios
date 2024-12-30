//
//  ZeusOnboardingView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 26/12/2024.
//

import SwiftUI

struct ZeusOnboardingView: View {
    @AppStorage(GlobalConstants.StorageKeys.Zeus.onboarding) var onboardingFinished = false

    var body: some View {
        VStack {
            ZeusInputConfigView()
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
        .padding(.bottom, 15)
    }
}

#Preview {
    ZeusOnboardingView()
}
