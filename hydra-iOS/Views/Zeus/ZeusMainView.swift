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
                DataLoaderView(zeus.user, fetcher: zeus.loadUser) { user in
                    if let user = user {
                        VStack {
                            Text("Your Tab balance is:")
                            Text("Ƶ \(user.balanceDecimal())")
                                .font(.system(size: 30, weight: .semibold))
                        }
                    }
                }
                actionBtns
                ScrollView {
                    requests
                }
                Spacer()
            }
            .padding()
        }
    }

    var actionBtns: some View {
        HStack(spacing: 30) {
            if zeus.hasDoorControl() {
                Button {
                    Task {
                        await zeus.controlDoor(.close)
                    }
                } label: {
                    Label("", systemImage: "lock.open")
                        .labelStyle(.iconOnly)
                }
                .buttonStyle(.bordered)

                Button {
                    Task {
                        await zeus.controlDoor(.open)
                    }
                } label: {
                    Label("", systemImage: "lock")
                        .labelStyle(.iconOnly)
                }
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

    var requests: some View {
        DataLoaderView(zeus.tabRequests, fetcher: zeus.loadTabRequests) { requests in
            if requests.isEmpty {
                EmptyView()
            } else {
                VStack {
                    Text("Verzoeken")
                        .font(.title2)
                        .bold()
                        .align(.left)
                    ForEach(requests) { request in
                        ZeusTransactionView(transaction: request, zeus: zeus)
                    }
                }
            }
        }
    }
}

struct ZeusTransactionView: View {
    var transaction: TabTransaction
    @ObservedObject var zeus: ZeusDocument
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray5))
            HStack {
                VStack {
                    Text("Ƶ\(transaction.amountDecimal()) to \(transaction.creditor)")
                        .bold()
                        .align(.left)
                    Text(transaction.message)
                        .align(.left)
                }
                Spacer()
                if transaction.canReject() {
                    Button("", systemImage: "x.circle") {
                        Task {
                            await zeus.executeRequestAction(
                                for: transaction.id, action: .decline)
                        }
                    }
                }
                if transaction.canAccept() {
                    Button("", systemImage: "checkmark.circle") {
                        Task {
                            await zeus.executeRequestAction(
                                for: transaction.id, action: .confirm)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ZeusMainView(zeus: ZeusDocument())
}
