//
//  WeatherDetailView.swift
//  Weather-App
//
//  Created by Ayesha Shaikh on 9/24/24.
//

import SwiftUI

struct WeatherDetailView: View {
    var body: some View {
        VStack {
            Text("Weather Detail")
                .font(.largeTitle)
            Image(systemName: "cloud.sun.fill")
                .resizable()
                .frame(width: 100, height: 100)
        }
        .padding()
    }
}

