import SwiftUI

struct SimpleTextView: UIViewRepresentable {

    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .white
        textView.textColor = .black
        textView.delegate = context.coordinator

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>

        init(_ text: Binding<String>) {
            self.text = text
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
}
