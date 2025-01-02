//
//  TabTransaction.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 31/12/2024.
//

import Foundation

struct TabTransaction: Decodable, Identifiable {
    let id: Int
    let debtor: String
    let creditor: String
    let time: String
    let amount: Int
    let issuer: String
    let message: String
    let actions: [String]?

    func amountDecimal() -> String {
        return (Double(amount) / 100).formatted(.currency(code: ""))
    }

    func adjustedAmount(from user: String) -> Int {
        if user == debtor {
            return -amount
        } else {
            return amount
        }
    }

    func displayOtherParty(from user: String) -> String {
        let other = otherParty(from: user)
        if other == "Tab" {
            return "Zeus"
        }
        return other
    }

    func otherParty(from user: String) -> String {
        if user == debtor {
            return creditor
        } else {
            return debtor
        }
    }
    
    func canAccept() -> Bool {
        return actions?.contains("confirm") ?? false
    }
    
    func canReject() -> Bool {
        return actions?.contains("decline") ?? false
    }
}
