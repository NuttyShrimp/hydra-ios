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
                    VStack {
                        Text("Your Tab balance is:")
                        Text("Ƶ \(user.balanceDecimal())")
                            .font(.system(size: 30, weight: .semibold))
                    }
                }
                actionBtns
                ScrollView {
                    requests
                    Divider()
                    transactions
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
                        ZeusTransactionView(transaction: request, hideIcon: true, zeus: zeus)
                    }
                }
            }
        }
    }

    var transactions: some View {
        DataLoaderView(
            zeus.tabTransaction, fetcher: zeus.loadTabTransactions,
            label: { Text("Loading transactions") }
        ) { transactions in
            if transactions.isEmpty {
                EmptyView()
            } else {
                VStack {
                    Text("Transacties")
                        .font(.title2)
                        .bold()
                        .align(.left)
                    ForEach(transactions) { request in
                        ZeusTransactionView(transaction: request, zeus: zeus)
                    }
                }
            }
        }
    }
}

struct ZeusTransactionView: View {
    var transaction: TabTransaction
    var hideIcon = false
    @ObservedObject var zeus: ZeusDocument
    @AppStorage(GlobalConstants.StorageKeys.Zeus.username) var username = ""

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray5))
            HStack {
                if !hideIcon {
                    icon
                }
                VStack {
                    Text(
                        "Ƶ\(transaction.amountDecimal()) \(transaction.creditor == username ? "from" : "to") \(transaction.displayOtherParty(from: username))"
                    )
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

    var icon: some View {
        ZStack {
            Image(transaction.thumbnail(for: username))
                .resizable()
                .scaledToFit()
                .frame(width: Constants.iconSize, height: Constants.iconSize)
        }
    }

    struct Constants {
        static let iconSize: CGFloat = 50
    }
}

#Preview {
    ZeusMainView(zeus: ZeusDocument())
}
