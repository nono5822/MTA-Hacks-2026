//
//  UrgencyMeter.swift
//  Seal Sensei
//
//  Visual dial/gauge for overall_urgency_score (1–10). Flashes red when 8–10.
//

import SwiftUI

struct UrgencyMeter: View {
    let score: Double
    @State private var isPulsing = false

    private var normalizedScore: Double { min(10, max(0, score)) }
    private var isHighUrgency: Bool { normalizedScore >= 8 }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Background arc
                Circle()
                    .trim(from: 0.25, to: 0.75)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)
                    .rotationEffect(.degrees(90))

                // Filled arc
                Circle()
                    .trim(from: 0.25, to: 0.25 + (normalizedScore / 10) * 0.5)
                    .stroke(
                        isHighUrgency ? Color.red : Color.orange,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(90))
                    .opacity(isHighUrgency && isPulsing ? 0.85 : 1)

                Text(String(format: "%.1f", normalizedScore))
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundStyle(isHighUrgency ? Color.red : .primary)
            }
            .frame(width: 160, height: 100)

            Text("Urgency")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .onAppear {
            if isHighUrgency {
                withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        UrgencyMeter(score: 5)
        UrgencyMeter(score: 9)
    }
    .padding()
}
