import SwiftUI

struct UpdatingView: View {
    @Binding var sentences: [Sentence]
    @Binding var showingUpdatingModal: Bool
    let editingSentenceID: String
    @Binding var korean: String
    @Binding var english: String
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: 30)
                Button(
                    action: {
                        guard korean.count != 0 && english.count != 0 else {
                            showingAlert.toggle()
                            alertMessage = "한국어 혹은 영어 입력이 없습니다"
                            return
                        }
                        
                        SentenceManager.shared.update(
                            id: editingSentenceID,
                            korean: korean,
                            english: english
                        )
                        showingUpdatingModal = false
                        sentences = []
                        sentences = SentenceManager.shared.all
                    },
                    label: {
                        Text("수정하기")
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
                SimpleTextView(text: $korean)
                    .frame(
                        width: geometry.size.width * 0.9,
                        height: nil,
                       alignment: .center
                    )
                    .border(.gray, width: 1)
                Button(action: {
                    Task {
                        guard korean.count != 0 else {
                            showingAlert = true
                            alertMessage = "번역할 한국어를 입력해주세요"
                            return
                        }
                        
                        do {
                            let data = try await PapagoManager.shared.translate(korean: korean)
                            guard let response = try? JSONDecoder().decode(PapagoManager.Response.self, from: data) else {
                                showingAlert = true
                                alertMessage = "JSON Parsing Error"
                                return
                            }
                            english = response.message.result?.translatedText ?? ""
                        } catch {
                            showingAlert = true
                            alertMessage = error.localizedDescription
                        }
                    }
                }, label: {
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
                SimpleTextView(text: $english)
                    .frame(
                        width: geometry.size.width * 0.9,
                        height: nil,
                       alignment: .center
                    )
                    .border(.gray, width: 1)
            }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }.background(Color(UIConfig.overallColor))
        .alert(isPresented: $showingAlert) {
            Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

