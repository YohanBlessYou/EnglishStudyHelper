import SwiftUI

struct AddingView: View {
    @State private var korean: String = ""
    @State private var english: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: 30)
                Button(
                    action: {},
                    label: {
                        Text("추가하기")
                            .foregroundColor(Color.black)
                            .font(.title2)
                    })
                    .frame(
                        width: geometry.size.width * 0.5,
                        height: nil,
                        alignment: .center
                    )
                    .padding(.vertical, 10)
                    .background(Color.green)
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
                Button(action: {}, label: {
                    Text("파파고 번역")
                        .padding(.vertical, 10)
                        .font(.title3)
                })
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
    }
}

#if DEBUG
struct AddingView_Previews: PreviewProvider {
    static var previews: some View {
        AddingView()
    }
}
#endif
