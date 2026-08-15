//
//  ContentView.swift
//  order-up
//
//  Created by YJ Soon on 14/8/26.
//

import SwiftUI

struct ContentView: View {
    @State private var a = 0
    @State private var teh = 0
    @State private var toast = 0
    @State private var flag = false
    @State private var tmp = 0
    @State private var arr: [String] = []
    @State private var confetti: [ConfettiParticle] = []
    @State private var rising = false
    @State private var falling = false

    func launchConfetti() {
        falling = false
        rising = false
        confetti = (0..<48).map { _ in
            ConfettiParticle(
                color: [Color.pink, .mint, .yellow, .teal, .cyan, .indigo, .orange, .purple].randomElement()!,
                size: CGFloat.random(in: 8...14),
                x: CGFloat.random(in: -180...180),
                upY: -CGFloat.random(in: 120...420),
                fallY: CGFloat.random(in: 120...520),
                rotStart: Double.random(in: 0...360),
                rotEnd: Double.random(in: 360...900)
            )
        }
        Task {
            try? await Task.sleep(for: .seconds(0.05))
            withAnimation(.easeOut(duration: 0.6)) {
                rising = true
            }
        }
        Task {
            try? await Task.sleep(for: .seconds(0.6))
            withAnimation(.easeIn(duration: 1.9)) {
                rising = false
                falling = true
            }
        }
        Task {
            try? await Task.sleep(for: .seconds(4.0))
            withAnimation(.easeOut(duration: 0.3)) {
                confetti = []
                falling = false
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
        VStack(spacing: 20) {
            Text("Order Up")
                .font(.largeTitle)
                .bold()

            Text("Kopitiam snacks. Tap + to add.")
                .font(.title3)
                .foregroundStyle(.secondary)

            HStack {
                Text("🥤  Milo")
                    .font(.title2)
                Text("$1.50")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(a)")
                    .font(.title)
                    .monospacedDigit()
                Button {
                    a += 1
                    tmp = 1
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                }
            }
            .padding()
            .background(Color.orange.opacity(0.18))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack {
                Text("🍵  Teh")
                    .font(.title2)
                Text("$1.20")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(teh)")
                    .font(.title)
                    .monospacedDigit()
                Button {
                    teh += 1
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                }
            }
            .padding()
            .background(Color.brown.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack {
                Text("🍞  Kaya Toast")
                    .font(.title2)
                Text("$2.00")
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(toast)")
                    .font(.title)
                    .monospacedDigit()
                Button {
                    toast += 1
                    arr.append("x")
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                }
            }
            .padding()
            .background(Color.yellow.opacity(0.22))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text("Total  $\(Double(a) * 1.5 + Double(teh) * 1.2 + Double(toast) * 2.0, specifier: "%.2f")")
                .font(.title)
                .bold()
                .padding(.top, 8)

            Button("Place Order") {
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .font(.title2)

            Button("Reset") {
                a = 0
                teh = 0
                toast = 0
            }
        }
        .padding(20)

            HStack(alignment: .bottom, spacing: 40) {
                TungTungSahurShape()
                    .onTapGesture {
                        launchConfetti()
                    }
            }
            .offset(y: 85)

            ForEach(confetti) { p in
                Circle()
                    .fill(p.color)
                    .frame(width: p.size, height: p.size)
                    .rotationEffect(.degrees(falling ? p.rotEnd : p.rotStart))
                    .offset(x: p.x, y: falling ? p.fallY : (rising ? p.upY : 0))
                    .opacity(falling ? 0.05 : 1)
                    .animation(.easeOut(duration: 0.6), value: rising)
                    .animation(.easeIn(duration: 1.9), value: falling)
            }
            .allowsHitTesting(false)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    let color: Color
    let size: CGFloat
    let x: CGFloat
    let upY: CGFloat
    let fallY: CGFloat
    let rotStart: Double
    let rotEnd: Double
}

struct TungTungSahurShape: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.brown)
                .frame(width: 130, height: 130)
                .offset(y: 40)
            Circle()
                .fill(Color.orange)
                .frame(width: 100, height: 100)
                .offset(y: 20)
            HStack(spacing: 26) {
                Circle()
                    .fill(.white)
                    .frame(width: 18, height: 18)
                    .overlay {
                        Circle()
                            .fill(.black)
                            .frame(width: 8, height: 8)
                            .offset(x: 2, y: 2)
                    }
                    .offset(y: -12)
                Circle()
                    .fill(.white)
                    .frame(width: 18, height: 18)
                    .overlay {
                        Circle()
                            .fill(.black)
                            .frame(width: 8, height: 8)
                            .offset(x: 2, y: 2)
                    }
                    .offset(y: -12)
            }
            Rectangle()
                .fill(Color.brown)
                .frame(width: 130, height: 6)
                .offset(y: 70)
        }
        .frame(width: 150, height: 150)
    }
}

#Preview {
    ContentView()
}
