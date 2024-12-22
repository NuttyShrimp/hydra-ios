//
//  OnboardingWelcome.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 21/12/2024.
//

import SwiftUI

struct OnboardingWelcome: View {
    @Binding var currentPage: Int
    
    var body: some View {
        VStack {
            Image("HydraLogo")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.LogoSize)
            Text("Welkom in Hydra!")
                .font(Constants.Font.welcome)
                .padding(.top, Constants.Padding.welcome)
            Text("Dit is **DE** app voor de Gentse studenten. Ga verder om de app te personalizeren naar jouw noden!")
                .padding(.top, Constants.Padding.intro)
            Spacer()
            Button(action: {
                currentPage = 1
            }, label: {
                HStack{
                    Spacer()
                    Label("Verder", systemImage: "arrow.right")
                    Spacer()
                }
                .padding(.vertical, Constants.Padding.button)
            })
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    struct Constants {
        static let LogoSize: CGFloat = 150
        struct Padding {
            static let welcome: CGFloat = 150
            static let intro: CGFloat = 10
            static let button: CGFloat = 7
        }
        struct Font {
            static let welcome: SwiftUI.Font = SwiftUI.Font.system(size: 22, weight: .semibold)
        }
    }
}

#Preview {
    @State var currentPage: Int = 0
    OnboardingWelcome(currentPage: $currentPage)
}
