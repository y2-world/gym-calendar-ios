//
//  ContentView.swift
//  GymCalendar
//
//  Created by Yuki Yoshida on 2026/06/08.
//

import SwiftUI

struct ContentView: View {
    @State private var checkins: [String] = []

    var body: some View {
        NavigationView {
            List(checkins, id: \.self) { date in
                Text(date)
            }
            .navigationTitle("ジム記録")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("チェックイン") {
                        checkin()
                    }
                }
                #endif
            }
        }
        .onAppear {
            fetchCheckins()
        }
    }

    func checkin() {
        guard let url = URL(string: "http://localhost:8000/checkins") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { _, _, _ in
            fetchCheckins()
        }.resume()
    }

    func fetchCheckins() {
        guard let url = URL(string: "http://localhost:8000/checkins") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let json = try? JSONDecoder().decode([String: [String]].self, from: data) else { return }
            DispatchQueue.main.async {
                checkins = json["checkins"] ?? []
            }
        }.resume()
    }
}
