import SwiftUI

struct StudyingView: View {
    @State private var sentences: [Sentence] = []
    @State private var studyingSentence: Sentence? = nil
    @State private var korean: String = ""
    @State private var english: String = ""
    @State private var koreanIsVisible: Bool = true
    @State private var englishIsVisible: Bool = false
    
    @State private var showingEditingActionsheet = false
    @State private var showingUpdatingModal = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("한국어 문장")
                    .frame(width: geometry.size.width,
                           height: nil,
                           alignment: .leading)
                    .padding(.vertical, 10)
                    .padding(.leading, 50)
                    .font(.title3)
                    .foregroundColor(.black)
                StudyingTextView(text: $korean, isVisible: $koreanIsVisible)
                    .frame(
                        width: geometry.size.width * 0.9,
                        height: nil,
                       alignment: .center
                    )
                    .border(.gray, width: 1)
                
                HStack(alignment: .center, spacing: geometry.size.width * 0.2) {
                    Button(action: {
                        englishIsVisible.toggle()
                    }, label: {
                        Text("정답보기")
                            .padding(.vertical, 10)
                            .font(.title3)
                    })
                    Button(action: {
                        studyingSentence = sentences.randomElement()
                        korean = studyingSentence?.korean ?? ""
                        english = studyingSentence?.english ?? ""
                        englishIsVisible = false
                    }, label: {
                        Text("다음문장")
                            .padding(.vertical, 10)
                            .font(.title3)
                    })
                }.frame(
                    width: geometry.size.width * 0.9,
                    height: nil,
                    alignment: .center
                )
                
                Text("영어 문장")
                    .frame(width: geometry.size.width,
                           height: nil,
                           alignment: .leading)
                    .padding(.vertical, 10)
                    .padding(.leading, 50)
                    .font(.title3)
                    .foregroundColor(.black)
                StudyingTextView(text: $english, isVisible: $englishIsVisible)
                    .frame(
                        width: geometry.size.width * 0.9,
                        height: nil,
                       alignment: .center
                    )
                    .border(.gray, width: 1)
            }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }.background(Color(UIConfig.overallColor))
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                Button(action: {
                    showingEditingActionsheet = true
                }, label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.blue)
                })
            }.onAppear {
                sentences = SentenceManager.shared.all
                studyingSentence = sentences.randomElement()
                korean = studyingSentence?.korean ?? ""
                english = studyingSentence?.english ?? ""
            }.confirmationDialog("", isPresented: $showingEditingActionsheet, titleVisibility: .automatic) {
                Button("수정") {
                    showingUpdatingModal = true
                }
                Button("삭제", role: .destructive) {
                    if let studyingSentence = studyingSentence {
                        SentenceManager.shared.delete(id: studyingSentence.id!)
                    }
                    sentences = SentenceManager.shared.all
                    studyingSentence = sentences.randomElement()
                    korean = studyingSentence?.korean ?? ""
                    english = studyingSentence?.english ?? ""
                }
                Button("취소", role: .cancel){}
            }.sheet(isPresented: self.$showingUpdatingModal) {
                if let studyingSentence = studyingSentence {
                    UpdatingView(sentences: self.$sentences, showingUpdatingModal: self.$showingUpdatingModal, editingSentenceID: studyingSentence.id!, korean: $korean, english: $english)
                }
            }
    }
}
