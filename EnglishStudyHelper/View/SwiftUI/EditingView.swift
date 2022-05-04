import SwiftUI

struct EditingView: View {
    
    @State
    private var sentences: [Sentence] = SentenceManager.shared.all
    
    var body: some View {
        GeometryReader { geometry in
            List(sentences){ sentence in
                Text(sentence.korean!)
            }.background(Color(UIConfig.overallColor))
        }.background(Color(UIConfig.overallColor))
    }
}

struct EditingView_Previews: PreviewProvider {
    static var previews: some View {
        EditingView()
    }
}
