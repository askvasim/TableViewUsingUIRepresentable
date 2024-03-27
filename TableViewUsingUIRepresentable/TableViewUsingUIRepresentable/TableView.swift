//
//  ContentView.swift
//  TableViewUsingUIRepresentable
//
//  Created by Vasim Khan on 3/27/24.
//

import SwiftUI

struct TableView: View {
    @State var categoriesList: [ExpenseCategory] = ExpenseCategory.dummyData
    @State var expenseCategoriesList: [ExpenseCategory] = ExpenseCategory.dummyExpenseData
    @State var isBottomSheetTapped: Bool = false
    
    var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_IN")
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        VStack {
            content()
        }
    }
    
    @ViewBuilder
    func content() -> some View {
        GeometryReader { geometry in
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        VStack(spacing: 10) {
                            Text("Expense Category List")
                                .font(.title)
                                .fontWeight(.semibold)
                            
                            Text("UIKIT TableView inside SwiftUI with \nfull features using UIViewRepresentable")
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                                .font(.body)
                        }
                        
                        VStack {
                            CategoryList(expenseCategoriesList: $expenseCategoriesList, isBottomSheetTapped: $isBottomSheetTapped)
                                .padding(.horizontal, 20)
                                .cornerRadius(10)
                        }
                        .frame(height: CGFloat(expenseCategoriesList.count * 72))
                        .padding(.top, 60)
                        
                    }
                }
                .padding(.vertical, 20)
                
                Spacer()
            }
            .background(.white)
            .padding(.bottom, 10)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .sheet(isPresented: $isBottomSheetTapped) {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .leading) {
                        ZStack(alignment: .center) {
                            Text("Add Category".uppercased())
                                .font(.body)
                            
                            HStack {
                                Button {
                                    isBottomSheetTapped.toggle()
                                } label: {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .foregroundColor(.black)
                                        .rotationEffect(.degrees(45))
                                        .frame(width: 22, height: 22)
                                }
                                
                                Spacer()
                            }
                        }
                        .padding(.top, 18)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 25)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            categories()
                        }
                    }
                }
                .presentationDetents([.large, .large])
            }
        }
    }
    
    @ViewBuilder
    func categories() -> some View {
        VStack (alignment: .leading, spacing: 20) {
            VStack {
                ForEach(categoriesList.indices, id: \.self) { index in
                    HStack(spacing: 10) {
                        HStack {
                            Button(action: {
                                addExpenseCategory(icon: categoriesList[index].icon, name: categoriesList[index].name, color: categoriesList[index].color)
                                
                            }) {
                                ZStack {
                                    Circle()
                                        .frame(width: 44, height: 44)
                                        .foregroundColor(categoriesList[index].color)
                                    
                                    Image(systemName: categoriesList[index].icon)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.black)
                                }
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(categoriesList[index].name)
                                        .lineLimit(1)
                                        .font(.body)
                                        .foregroundColor(.black)
                                }
                                
                                Spacer()
                            }
                        }
                    }
                    if index != categoriesList.count - 1 {
                        Rectangle()
                            .foregroundStyle(Color.gray.opacity(0.5))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, maxHeight: 1)
                            .padding(.vertical, 10)
                    }
                }
            }
            .padding(.all, 15)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
    }
    
    private func addExpenseCategory(icon: String, name: String, color: Color) {
        let newExpenseCategory = ExpenseCategory(icon: icon, name: name, color: color)
        expenseCategoriesList.insert(newExpenseCategory, at: expenseCategoriesList.count - 1) // Add at the last second of the array
            isBottomSheetTapped = false // Close bottom sheet after adding category
    }
}

#Preview {
    TableView()
}
