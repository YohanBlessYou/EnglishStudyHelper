import SwiftUI

struct EditingView: View {
    @State private var sentences: [Sentence] = SentenceManager.shared.all
    @State private var showingEditingActionsheet = false
    @State private var editingSentence: Sentence! = nil
    @State private var showingUpdatingModal = false
    
    var body: some View {
        GeometryReader { geometry in
            List(sentences){ sentence in
                Button(sentence.korean!) {
                    editingSentence = sentence
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
                    SentenceManager.shared.delete(id: editingSentence.id!)
                    sentences = SentenceManager.shared.all
                }
                Button("취소", role: .cancel){}
            }.sheet(isPresented: self.$showingUpdatingModal) {
                UpdatingView(sentences: self.$sentences, showingUpdatingModal: self.$showingUpdatingModal, editingSentenceID: editingSentence.id!, korean: editingSentence.korean!, english: editingSentence.english!)
            }
            .onAppear {
                sentences = SentenceManager.shared.all
            }
    }
}
