//
//  LabelValueUi.swift
//  DigiDex
//
//  Reusable component for displaying label-value pairs
//

import SwiftUI

struct LabelValueUi: View {
    let labelValue: LabelValueModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(labelValue.label)
                .font(.headline)
                .bold()

            HStack(spacing: 8) {
                ForEach(labelValue.value ?? [], id: \.self) { val in
                    if val.hasPrefix("http") {
                        AsyncImage(url: URL(string: val)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 40, height: 40)
                        .clipped()
                    } else {
                        Text(val)
                            .font(.system(size: 12))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    VStack(spacing: 16) {
        LabelValueUi(
            labelValue: LabelValueModel(label: "Skills", value: ["Fire", "Water", "Earth"]))
        LabelValueUi(
            labelValue: LabelValueModel(label: "Type", value: ["Dragon"]))
    }
    .padding()
}
