//
//  UIViewRepresentable.swift
//  TableViewUsingUIRepresentable
//
//  Created by Vasim Khan on 3/27/24.
//

import SwiftUI
import UIKit

class HostingCell: UITableViewCell { // just to hold hosting controller
    var host: UIHostingController<AnyView>?
}

struct CategoryList: UIViewRepresentable {
    @Binding var expenseCategoriesList: [ExpenseCategory]
    @Binding var isBottomSheetTapped: Bool

    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 10
        tableView.alwaysBounceVertical = false
        tableView.isScrollEnabled = false
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.register(HostingCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }

    func updateUIView(_ uiView: UITableView, context: Context) {
        if !isBottomSheetTapped {
            DispatchQueue.main.async {
                uiView.reloadData()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(expenseCategoriesList: $expenseCategoriesList, bottomSheet: $isBottomSheetTapped)
    }

    class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {

        @Binding var expenseCategoriesList: [ExpenseCategory]
        @Binding var isBottomSheetTapped: Bool
        
        var formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_IN")
            formatter.maximumFractionDigits = 0
            return formatter
        }()

        init(expenseCategoriesList: Binding<[ExpenseCategory]>, bottomSheet: Binding<Bool>) {
            self._expenseCategoriesList = expenseCategoriesList
            self._isBottomSheetTapped = bottomSheet
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            self.expenseCategoriesList.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HostingCell
            
            // Configure the SwiftUI view inside the table view cell
            let view = ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .frame(width: 44, height: 44)
                                .foregroundColor(expenseCategoriesList[indexPath.item].color)
                            
                            Image(systemName: expenseCategoriesList[indexPath.item].icon)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 18, height: 18)
                        }
                        
                        Text(expenseCategoriesList[indexPath.item].name)
                            .font(.body)
                        
                        Spacer()
                    }
                    .padding(.vertical, 14)
                    
                    Rectangle()
                        .foregroundStyle(Color.gray.opacity(0.3))
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 1)
                }
                .padding(.horizontal, 20)
            }
            
            if (indexPath.row == self.expenseCategoriesList.count-1) {
                tableViewCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            }
            
            // Set up hosting controller for SwiftUI view
            if tableViewCell.host == nil {
                let controller = UIHostingController(rootView: AnyView(view))
                tableViewCell.host = controller
                
                let tableCellViewContent = controller.view!
                tableCellViewContent.translatesAutoresizingMaskIntoConstraints = false
                tableViewCell.contentView.addSubview(tableCellViewContent)
                // Configure constraints for the hosting controller's view
                tableCellViewContent.topAnchor.constraint(equalTo: tableViewCell.contentView.topAnchor).isActive = true
                tableCellViewContent.leftAnchor.constraint(equalTo: tableViewCell.contentView.leftAnchor).isActive = true
                tableCellViewContent.bottomAnchor.constraint(equalTo: tableViewCell.contentView.bottomAnchor).isActive = true
                tableCellViewContent.rightAnchor.constraint(equalTo: tableViewCell.contentView.rightAnchor).isActive = true
                tableCellViewContent.backgroundColor = .gray.withAlphaComponent(0.15)
                
                tableView.reloadData()
            } else {
                // Reuse existing hosting controller and update SwiftUI view
                tableViewCell.host?.rootView = AnyView(view)
            }
            tableViewCell.setNeedsLayout()
            return tableViewCell
        }
        
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            if expenseCategoriesList[indexPath.item].name != "Add category" {
                let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                    // delete the item here
                    self.expenseCategoriesList.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    completionHandler(true)
                }
                deleteAction.image = UIImage(systemName: "trash")
                deleteAction.backgroundColor = .systemRed
                let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
                return configuration
            } else {
                return nil
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if expenseCategoriesList[indexPath.item].name == "Add category" {
                    self.isBottomSheetTapped = true
            }
        }
    }
}
