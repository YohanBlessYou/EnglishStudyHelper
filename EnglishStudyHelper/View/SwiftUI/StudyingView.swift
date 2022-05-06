import SwiftUI

struct StudyingView: View {
    @State
    private var korean: String = ""
    
    @State
    private var english: String = ""
    
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
                TextView(text: $korean)
                    .frame(
                        width: geometry.size.width * 0.9,
                        height: nil,
                       alignment: .center
                    )
                    .border(.gray, width: 1)
                
                HStack(alignment: .center, spacing: geometry.size.width * 0.2) {
                    Button(action: {}, label: {
                        Text("정답보기")
                            .padding(.vertical, 10)
                            .font(.title3)
                    })
                    Button(action: {}, label: {
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
                TextView(text: $korean)
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
                    
                }, label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.blue)
                })
            }
    }
}

#if DEBUG
struct StudyingView_Previews: PreviewProvider {
    static var previews: some View {
        StudyingView()
    }
}
#endif
