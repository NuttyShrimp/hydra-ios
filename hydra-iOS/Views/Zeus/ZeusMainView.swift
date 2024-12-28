//
//  ZeusMainView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 26/12/2024.
//

import LucideIcons
import SwiftUI

struct ZeusMainView: View {
    @ObservedObject var zeus: ZeusDocument

    var body: some View {
        NavigationStack {
            VStack {
                Text("Your tab balance:")
                Text("Ƶ 100.00")
                    .font(.system(size: 30, weight: .semibold))
                actionBtns
                Spacer()
            }
            .padding()
        }
    }
    
    var actionBtns: some View {
        HStack(spacing: 30) {
            if zeus.hasDoorControl() {
                Button(
                    "", systemImage: "lock.open",
                    action: {
                        print("unlock")
                    }
                ).labelStyle(.iconOnly)
                    .buttonStyle(.bordered)
                Button(
                    "", systemImage: "lock",
                    action: {
                        print("lock")
                    }
                )
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)
            }
            NavigationLink(
                destination: {
                    ZeusCammieView(zeus: zeus)
                        .navigationTitle("Zeus cammie")
                },
                label: {
                    Label("", systemImage: "video")
                        .labelStyle(.iconOnly)
                }
            )
            .buttonStyle(.bordered)
            .foregroundStyle(Color(.accent))

        }
    }
}

#Preview {
    ZeusMainView(zeus: ZeusDocument())
}