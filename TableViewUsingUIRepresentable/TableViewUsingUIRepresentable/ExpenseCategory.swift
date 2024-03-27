//
//  DataModel.swift
//  TableViewUsingUIRepresentable
//
//  Created by Vasim Khan on 3/27/24.
//

import SwiftUI

struct ExpenseCategory: Identifiable {
    let id = UUID()
    let icon: String
    let name: String
    let color: Color
    
    // Data to display in the TableView list (UIViewRepresentable)
    static var dummyExpenseData: [ExpenseCategory] {
        return [
            ExpenseCategory(icon: "dollarsign.square", name: "Liabilities", color: .pink.opacity(0.5)),
            ExpenseCategory(icon: "dollarsign.circle", name: "Savings", color: .green.opacity(0.5)),
            ExpenseCategory(icon: "face.smiling", name: "Lifestyle", color: .purple.opacity(0.5)),
            ExpenseCategory(icon: "plus", name: "Add category", color: Color.gray.opacity(0.4))
        ]
    }
    
    // Data to display the listView of category on the sheet
    static var dummyData: [ExpenseCategory] {
        return [
            ExpenseCategory(icon: "hands.clap", name: "Entertainment", color: .red.opacity(0.4)),
            ExpenseCategory(icon: "hands.clap", name: "Food & Drinks", color: .yellow.opacity(0.4)),
            ExpenseCategory(icon: "hands.clap", name: "Beverages", color: .blue.opacity(0.4)),
            ExpenseCategory(icon: "hands.clap", name: "Housing", color: .teal.opacity(0.4)),
            ExpenseCategory(icon: "hands.clap", name: "Income", color: .orange.opacity(0.4)),
            ExpenseCategory(icon: "face.smiling", name: "Lifestyle", color: .purple.opacity(0.4)),
            ExpenseCategory(icon: "hands.clap", name: "Miscellaneous", color: .cyan.opacity(0.4)),
            ExpenseCategory(icon: "dollarsign.circle", name: "Savings", color: .green.opacity(0.4)),
            ExpenseCategory(icon: "hands.clap", name: "Transportation", color: .mint.opacity(0.4)),
            ExpenseCategory(icon: "dollarsign.square", name: "Liabilities", color: .pink.opacity(0.4)),
        ]
    }
}
