import SwiftUI

struct MainView: View {
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack(alignment: .center, spacing: 20) {
                    Image("logo")
                    Button(
                        action: {},
                        label: {
                            Image("play")
                            Text("시작하기")
                                .font(Font(UIConfig.textFont))
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                        })
                        .frame(width: geometry.size.width * 0.65, height: nil, alignment: .leading)
                        .padding(.vertical, 10)
                        .padding(.leading, 15)
                        .background(Color(UIConfig.bigContentColor))
                        .cornerRadius(10)
                    Button(
                        action: {},
                        label: {
                            Image("edit")
                            Text("편집하기")
                                .font(Font(UIConfig.textFont))
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                        })
                        .frame(width: geometry.size.width * 0.65, height: nil, alignment: .leading)
                        .padding(.vertical, 10)
                        .padding(.leading, 15)
                        .background(Color(UIConfig.bigContentColor))
                        .cornerRadius(10)
                    Button(
                        action: {},
                        label: {
                            Image("add")
                            Text("문장추가")
                                .font(Font(UIConfig.textFont))
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                        })
                        .frame(width: geometry.size.width * 0.65, height: nil, alignment: .leading)
                        .padding(.vertical, 10)
                        .padding(.leading, 15)
                        .background(Color(UIConfig.bigContentColor))
                        .cornerRadius(10)
                    Button(
                        action: {},
                        label: {
                            Image("cloud")
                            Text("iCloud")
                                .font(Font(UIConfig.textFont))
                                .foregroundColor(.black)
                                .padding(.leading, 20)
                        })
                        .frame(width: geometry.size.width * 0.65, height: nil, alignment: .leading)
                        .padding(.vertical, 10)
                        .padding(.leading, 15)
                        .background(Color(UIConfig.bigContentColor))
                        .cornerRadius(10)
                }.frame(width: geometry.size.width * 0.7, height: nil, alignment: .center)
            }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }.background(Color(UIConfig.overallColor))
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
