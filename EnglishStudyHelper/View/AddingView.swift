import SwiftUI

struct AddingView: View {
    @Binding var showingAddingModal: Bool
    @State private var korean: String = ""
    @State private var english: String = ""
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
                        
                        SentenceManager.shared.create(korean: korean, english: english)
                        showingAddingModal.toggle()
                    },
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
                SimpleTextView(text: $korean)
                    .frame(
                        width: geometry.size.width * 0.9,
                        height: nil,
                       alignment: .center
                    )
                    .border(.gray, width: 1)
                Button(action: {
                    guard korean.count != 0 else {
                        showingAlert.toggle()
                        alertMessage = "번역할 한국어를 입력해주세요"
                        return
                    }
                    
                    PapagoManager.shared.translate(korean: korean) { result in
                        switch result {
                        case .success(let data):
                            guard let response = try? JSONDecoder().decode(PapagoManager.Response.self, from: data) else {
                                DispatchQueue.main.async {
                                    showingAlert.toggle()
                                    alertMessage = "JSON Parsing Error"
                                }
                                return
                            }
                            DispatchQueue.main.async {
                                english = response.message.result?.translatedText ?? ""
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                showingAlert.toggle()
                                alertMessage = error.description
                            }
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
