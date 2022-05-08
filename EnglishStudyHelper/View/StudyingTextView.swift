import SwiftUI

struct StudyingTextView: UIViewRepresentable {

    @Binding var text: String
    @Binding var isVisible: Bool

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.backgroundColor = .white
        textView.textColor = isVisible ? .black : .white
        textView.delegate = context.coordinator
        textView.isEditable = false

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.textColor = isVisible ? .black : .white
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
