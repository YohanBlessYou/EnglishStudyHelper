import SwiftUI

struct EditingView: View {
    @State private var sentences: [Sentence] = SentenceManager.shared.all
    @State private var showingEditingActionsheet = false
    @State private var editingSentence: Sentence? = nil
    @State private var showingUpdatingModal = false
    @State private var korean: String = ""
    @State private var english: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            List(sentences){ sentence in
                Button(sentence.korean!) {
                    editingSentence = sentence
                    korean = sentence.korean!
                    english = sentence.english!
                    showingEditingActionsheet = true
                }.foregroundColor(.black)
                    .listRowBackground(Color.white)
            }.onAppear {
                UITableView.appearance().backgroundColor = UIConfig.overallColor
            }
        }.background(Color(UIConfig.overallColor))
            .navigationBarTitle("", displayMode: .inline)
            .confirmationDialog("", isPresented: $showingEditingActionsheet, titleVisibility: .automatic) {
                Button("수정") {
                    showingUpdatingModal = true
                }
                Button("삭제", role: .destructive) {
                    if let editingSentence = editingSentence {
                        SentenceManager.shared.delete(id: editingSentence.id!)
                    }
                    sentences = SentenceManager.shared.all
                }
                Button("취소", role: .cancel){}
            }.sheet(isPresented: self.$showingUpdatingModal) {
                if let editingSentence = editingSentence {
                    UpdatingView(sentences: self.$sentences, showingUpdatingModal: self.$showingUpdatingModal, editingSentenceID: editingSentence.id!, korean: $korean, english: $english)
                }
            }
            .onAppear {
                sentences = SentenceManager.shared.all
            }
    }
}
