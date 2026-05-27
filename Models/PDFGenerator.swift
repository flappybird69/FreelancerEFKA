import SwiftUI
import PDFKit

struct InvoicePDFGenerator {
    static func generate(result: InvoiceResult, date: Date = Date()) -> Data {
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842))
        return renderer.pdfData { ctx in
            ctx.beginPage()

            let margin: CGFloat = 40
            var y: CGFloat = 40

            // Header
            drawText("INVOICE CALCULATION", x: margin, y: y, size: 20, bold: true, color: .black)
            y += 36

            drawText("Generated: \(date.formatted(date: .abbreviated, time: .shortened))", x: margin, y: y, size: 10, color: .gray)
            y += 40

            // Divider
            ctx.cgContext.setStrokeColor(UIColor.systemGray4.cgColor)
            ctx.cgContext.setLineWidth(1)
            ctx.cgContext.move(to: CGPoint(x: margin, y: y))
            ctx.cgContext.addLine(to: CGPoint(x: 595 - margin, y: y))
            ctx.cgContext.strokePath()
            y += 20

            // Line items
            drawRow("Net Amount", value: result.netAmount.currencyFormatted, y: y)
            y += 28
            drawRow("VAT (\((result.vatRate * 100).formatted(.number.precision(.fractionLength(0))))%)", value: result.vatAmount.currencyFormatted, y: y)
            y += 28
            drawRow("ΦΜΥ (20%)", value: "-\(result.withholdingTax.currencyFormatted)", y: y, valueColor: .systemRed)
            y += 36

            // Divider
            ctx.cgContext.setStrokeColor(UIColor.systemGray4.cgColor)
            ctx.cgContext.move(to: CGPoint(x: margin, y: y))
            ctx.cgContext.addLine(to: CGPoint(x: 595 - margin, y: y))
            ctx.cgContext.strokePath()
            y += 20

            drawRow("Client Pays (Gross)", value: result.grossAmount.currencyFormatted, y: y, bold: true)
            y += 32
            drawRow("You Receive (Net)", value: result.finalNet.currencyFormatted, y: y, bold: true, valueColor: UIColor.systemTeal)
            y += 50

            // Disclaimer
            drawText("Estimates based on AADE 2025 rates. ±5% margin.", x: margin, y: y, size: 9, color: .gray)
            y += 16
            drawText("Not affiliated with EFKA or AADE. Consult your λογιστής.", x: margin, y: y, size: 9, color: .gray)
        }
    }

    private static func drawText(_ text: String, x: CGFloat, y: CGFloat, size: CGFloat, bold: Bool = false, color: UIColor) {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: bold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size),
            .foregroundColor: color,
        ]
        (text as NSString).draw(at: CGPoint(x: x, y: y), withAttributes: attrs)
    }

    private static func drawRow(_ label: String, value: String, y: CGFloat, bold: Bool = false, valueColor: UIColor = .black) {
        let margin: CGFloat = 40
        drawText(label, x: margin, y: y, size: 13, bold: bold, color: bold ? .black : .darkGray)
        drawText(value, x: 595 - margin - 120, y: y, size: 13, bold: bold, color: valueColor)
    }
}

struct PDFPreviewView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.document = PDFDocument(data: data)
        view.autoScales = true
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
