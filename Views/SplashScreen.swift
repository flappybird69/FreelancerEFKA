import SwiftUI

struct SplashScreen: View {
    @State private var phase1 = false
    @State private var phase2 = false
    @State private var phase3 = false
    @State private var phase4 = false
    @State private var progress: CGFloat = 0
    @State private var sparkleSeed = (0..<24).map { _ in Sparkle() }
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()

            TimelineView(.animation(minimumInterval: 0.016)) { timeline in
                Canvas { ctx, size in
                    let date = timeline.date.timeIntervalSinceReferenceDate
                    for s in sparkleSeed {
                        let x = s.baseX + sin(date * s.speed + s.phase) * 60
                        let y = s.baseY + cos(date * s.speed * 0.7 + s.phase * 1.3) * 40
                        let alpha = 0.12 + 0.12 * sin(date * s.speed * 0.5 + s.phase)
                        let rect = CGRect(x: x, y: y, width: s.size, height: s.size)
                        ctx.opacity = alpha
                        let g = Gradient(colors: [Color.accentPurple, Color.accentPink])
                        ctx.fill(Path(ellipseIn: rect), with: .linearGradient(g, startPoint: rect.origin, endPoint: CGPoint(x: rect.maxX, y: rect.maxY)))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            VStack(spacing: 32) {
                Spacer()

                // Icon
                ZStack {
                    Circle()
                        .fill(Color.accentPurple.opacity(phase1 ? 0.15 : 0))
                        .frame(width: 130, height: 130)
                        .blur(radius: 26)

                    Image(systemName: "eurosign.circle.fill")
                        .font(.system(size: 68))
                        .foregroundStyle(LinearGradient.primaryGradient)
                        .scaleEffect(phase1 ? 1 : 0.6)
                        .opacity(phase1 ? 1 : 0)
                }

                // Text block
                VStack(spacing: 8) {
                    Text("Your Freelance Financial Companion")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                        .opacity(phase2 ? 1 : 0)
                        .offset(y: phase2 ? 0 : 18)

                    Text("EFKA · VAT · Property Guide")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .opacity(phase3 ? 1 : 0)
                        .offset(y: phase3 ? 0 : 12)
                }

                // Progress bar
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(width: 220, height: 6)

                    Capsule()
                        .fill(LinearGradient.primaryGradient)
                        .frame(width: 220 * progress, height: 6)

                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 32, height: 3)
                        .offset(x: -110 + 220 * progress)
                        .blur(radius: 3)
                }
                .opacity(phase3 ? 1 : 0)
                .animation(.linear(duration: 3.5), value: progress)

                Spacer()

                Text("Powered by Sephiance Inc.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 40)
                    .opacity(phase4 ? 1 : 0)
                    .offset(y: phase4 ? 0 : 10)
            }
        }
        .onAppear { animate() }
    }

    private func animate() {
        // Phase 1: Icon — spring in
        withAnimation(.spring(duration: 0.7, bounce: 0.2)) { phase1 = true }

        // Phase 2: Slogan — fluid slide + fade (staggered)
        withAnimation(.easeOut(duration: 0.8).delay(0.25)) { phase2 = true }

        // Phase 3: Subtitle + progress bar
        withAnimation(.easeOut(duration: 0.6).delay(0.6)) { phase3 = true }

        // Phase 4: Footer
        withAnimation(.easeOut(duration: 0.5).delay(0.9)) { phase4 = true }

        // Progress bar — single smooth animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            withAnimation(.linear(duration: 3.8)) { progress = 1 }
        }

        // Dismiss
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.2) {
            withAnimation(.easeOut(duration: 0.35)) { phase1 = false; phase2 = false; phase3 = false; phase4 = false }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { onComplete() }
        }
    }
}

// MARK: - Sparkle
private struct Sparkle {
    let baseX: CGFloat
    let baseY: CGFloat
    let size: CGFloat
    let speed: Double
    let phase: Double

    init() {
        baseX = CGFloat.random(in: 40...350)
        baseY = CGFloat.random(in: 80...500)
        size = CGFloat.random(in: 3...9)
        speed = 0.8 + Double.random(in: 0...1.5)
        phase = Double.random(in: 0...(2 * .pi))
    }
}

#Preview {
    SplashScreen(onComplete: {})
}
