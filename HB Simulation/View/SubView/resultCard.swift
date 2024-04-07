//
//  resultCard.swift
//  Simulation-A1-AmirMahdiAbravesh
//
//  Created by Amir Mahdi Abravesh on 4/7/24.
//

import SwiftUI

struct resultCard: View {
    var title: String
    var descriptions: [String]
    var results: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 30, weight: .bold))
            if descriptions.count != 0 && results.count != 0 {
                ForEach(0 ..< descriptions.count, id: \.self) { index in
                    HStack {
                        Text(descriptions[index])
                            .font(.system(size: 18, weight: .regular))
                        Spacer()
                        Text(results[index])
                            .font(.system(size: 18, weight: .regular))
                    }
                }
            }
        }
        .padding(15)
        .background(.thickMaterial)
        .cornerRadius(20)
    }
}

//#Preview {
//    resultCard()
//}
