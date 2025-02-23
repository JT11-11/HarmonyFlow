//
//  CategoryCard.swift
//  TCM
//
//  Created by Shadow33 on 20/2/25.
//
import SwiftUI

struct CategoryCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.white)
                .frame(width: 65, height: 65)
                .background(
                    Circle()
                        .fill(color)
                )
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
        }
        .frame(width: 120, height: 130)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
