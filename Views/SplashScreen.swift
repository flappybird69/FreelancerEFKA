import SwiftUI

struct SplashScreen: View {
    @State private var typingPhase = 0
    @State private var showSubtitle = false
    @State private var progress: CGFloat = 0
    @State private var ready = false
    @State private var sparkleSeed = (0..<20).map { _ in Sparkle() }
    let onComplete: () -> Void

    private let slogan = "Your Freelance Financial Companion"

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            TimelineView(.animation(minimumInterval: 0.016)) { timeline in
                Canvas { ctx, size in
                    let date = timeline.date.timeIntervalSinceReferenceDate
                    for s in sparkleSeed {
                        let x = s.baseX + sin(date * s.speed + s.phase) * 60
                        let y = s.baseY + cos(date * s.speed * 0.7 + s.phase * 1.3) * 40
                        let alpha = 0.15 + 0.15 * sin(date * s.speed + s.phase)
                        let rect = CGRect(x: x, y: y, width: s.size, height: s.size)
                        ctx.opacity = alpha
                        let gradient = Gradient(colors: [Color.accentPurple, Color.accentPink])
                        ctx.fill(Path(ellipseIn: rect), with: .linearGradient(gradient, startPoint: rect.origin, endPoint: CGPoint(x: rect.maxX, y: rect.maxY)))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            VStack(spacing: 28) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.accentPurple.opacity(0.1 + 0.08 * sin(CACurrentMediaTime())))
                        .frame(width: 140, height: 140)
                        .blur(radius: 28)

                    Image(systemName: "eurosign.circle.fill")
                        .font(.system(size: 72))
                        .foregroundStyle(LinearGradient.primaryGradient)
                        .modifier(PulseRotateModifier())
                }

                VStack(spacing: 6) {
                    Text(String(slogan.prefix(typingPhase)))
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .frame(height: 28)
                        .animation(.easeOut(duration: 0.03), value: typingPhase)

                    Text("EFKA · VAT · Property Guide")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .opacity(showSubtitle ? 1 : 0)
                        .offset(y: showSubtitle ? 0 : 10)
                }

                // Progress bar with shimmer
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(width: 220, height: 6)

                    Capsule()
                        .fill(LinearGradient.primaryGradient)
                        .frame(width: 220 * progress, height: 6)

                    Capsule()
                        .fill(Color.white.opacity(0.25))
                        .frame(width: 36, height: 4)
                        .offset(x: -110 + 220 * progress)
                        .blur(radius: 2)
                }
                .animation(.linear(duration: 3.5), value: progress)

                Spacer()

                Text("Powered by Sephiance Inc.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 40)
                    .opacity(ready ? 1 : 0)
                    .offset(y: ready ? 0 : 10)
            }
        }
        .onAppear { animate() }
    }

    private func animate() {
        withAnimation(.easeOut(duration: 0.5)) { ready = true }

        // Typewriter — efficient single-thread dispatch
        DispatchQueue.global(qos: .userInteractive).async {
            for i in 1...slogan.count {
                Thread.sleep(forTimeInterval: 0.04)
                DispatchQueue.main.async {
                    typingPhase = i
                    if i == slogan.count {
                        withAnimation(.easeOut(duration: 0.3)) { showSubtitle = true }
                    }
                }
            }
        }

        // Progress bar — single smooth animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.linear(duration: 3.5)) { progress = 1 }
        }

        // Dismiss after 4s
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            withAnimation(.easeOut(duration: 0.4)) { ready = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                onComplete()
            }
        }
    }
}

// MARK: - Smooth pulse + rotation (GPU-bound, not state-driven)
struct PulseRotateModifier: ViewModifier {
    @State private var phase: Double = 0

    func body(content: Content) -> some View {
        content
            .scaleEffect(1 + 0.1 * sin(phase * 1.5))
            .opacity(0.85 + 0.15 * sin(phase * 1.5))
            .rotationEffect(.degrees(phase * 45))
            .onAppear {
                withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                    phase = 8
                }
            }
    }
}

// MARK: - Sparkle particle
private struct Sparkle {
    let baseX: CGFloat
    let baseY: CGFloat
    let size: CGFloat
    let speed: Double
    let phase: Double

    init() {
        baseX = CGFloat.random(in: 40...350)
        baseY = CGFloat.random(in: 80...500)
        size = CGFloat.random(in: 3...8)
        speed = 1.0 + Double.random(in: 0...1.5)
        phase = Double.random(in: 0...(2 * .pi))
    }
}

#Preview {
    SplashScreen(onComplete: {})
}
