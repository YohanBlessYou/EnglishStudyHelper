import SwiftUI

struct EditingView: View {
    
    @State
    private var sentences: [Sentence] = SentenceManager.shared.all
    
    var body: some View {
        GeometryReader { geometry in
            List(sentences){ sentence in
                Text(sentence.korean!)
                    .foregroundColor(.black)
                    .listRowBackground(Color.white)
            }.onAppear {
                UITableView.appearance().backgroundColor = UIConfig.overallColor
            }
        }.background(Color(UIConfig.overallColor))
    }
}
