//
//  ZeusCammieView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 27/12/2024.
//

import SwiftUI
import AlertToast

struct ZeusCammieView: View {
    @ObservedObject var zeus: ZeusDocument
    @ObservedObject private var stream = MjpegStreamingController(
        contentURL: "https://kelder.zeus.ugent.be/camera/cammie")
    @State private var kelderMsg = ""
    @State private var isKelderMsgToastShowing = false {
        didSet {
            if !isKelderMsgToastShowing {
                zeus.messageState = .idle
            }
        }
    }

    let actions: [[ZeusCommand]] = [
        [.cammie(.northWest), .cammie(.north), .cammie(.northEast)],
        [.cammie(.west), .message, .cammie(.east)],
        [.cammie(.southWest), .cammie(.south), .cammie(.southEast)],
    ]

    var body: some View {
        VStack {
            Image(uiImage: stream.image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
            directionBtns
            VStack(spacing: 10) {
                ForEach(
                    [
                        ZeusCommand.cammie(.bigTable), .cammie(.smallTable), .cammie(.sofa),
                        .cammie(.door),
                    ], id: \.self
                ) { command in
                    Button(
                        command.label,
                        action: {
                            zeus.executeCommand(command)
                        }
                    )
                    .buttonStyle(.bordered)
                }
            }
            .padding(.top, 20)
            Spacer()
        }
        .padding()
        .alert("Bericht sturen naar de kelder", isPresented: $zeus.showMessageAlert) {
            TextField("Bericht", text: $kelderMsg)
            Button("Cancel", role: .cancel) {
            }
            Button(
                "OK",
                action: {
                    Task {
                        await zeus.sendKelderMessage(kelderMsg)
                        kelderMsg = ""
                        zeus.showMessageAlert = false
                        isKelderMsgToastShowing = true
                    }
                })
        }.toast(isPresenting: $isKelderMsgToastShowing) {
            if case .success = zeus.messageState {
                AlertToast(displayMode: .hud, type: .complete(.green), title: "Message Sent!")
            } else {
                AlertToast(displayMode: .hud, type: .error(.red), title: "Failed to send message")
            }
        }
    }

    var directionBtns: some View {
        VStack {
            ForEach(0..<3) { rowIdx in
                HStack {
                    ForEach(0..<3) { colIdx in
                        ZeusCommandBtn(
                            command: actions[rowIdx][colIdx], action: zeus.executeCommand)
                    }
                }
            }
        }
    }
}

struct ZeusCommandBtn: View {
    let command: ZeusCommand
    let action: (ZeusCommand) -> Void

    var body: some View {
        Button(
            "", systemImage: command.icon,
            action: {
                action(command)
            }
        )
        .labelStyle(.iconOnly)
        .buttonStyle(.bordered)
        .buttonBorderShape(.capsule)
    }
}

#Preview {
    ZeusCammieView(zeus: ZeusDocument())
}
