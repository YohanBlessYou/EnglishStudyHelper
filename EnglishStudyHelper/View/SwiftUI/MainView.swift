import SwiftUI

struct MainView: View {
    @State private var showingAddingModal = false

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                HStack {
                    VStack(alignment: .center, spacing: 20) {
                        Image("logo")
                            .resizable()
                            .frame(width: geometry.size.width * 0.65, height: geometry.size.width * 0.65, alignment: .center)
                        NavigationLink(destination: StudyingView()) {
                            HStack {
                                Image("play")
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15, alignment: .center)
                                Text("시작하기")
                                    .font(Font(UIConfig.textFont))
                                    .foregroundColor(.black)
                                    .padding(.leading, 20)
                            }.frame(width: geometry.size.width * 0.65, height: nil, alignment: .leading)
                                .padding(.vertical, 10)
                                .padding(.leading, 15)
                                .background(Color(UIConfig.bigContentColor))
                                .cornerRadius(10)
                        }
                        
                        NavigationLink(destination: EditingView()) {
                            HStack {
                                Image("edit")
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15, alignment: .center)
                                Text("편집하기")
                                    .font(Font(UIConfig.textFont))
                                    .foregroundColor(.black)
                                    .padding(.leading, 20)
                            }
                            .frame(width: geometry.size.width * 0.65, height: nil, alignment: .leading)
                            .padding(.vertical, 10)
                            .padding(.leading, 15)
                            .background(Color(UIConfig.bigContentColor))
                            .cornerRadius(10)
                        }
                        Button(
                            action: {
                                showingAddingModal.toggle()
                            },
                            label: {
                                Image("add")
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15, alignment: .center)
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
                            .sheet(isPresented: self.$showingAddingModal) {
                                            AddingView()
                                        }
                        Button(
                            action: {},
                            label: {
                                Image("cloud")
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.15, height: geometry.size.width * 0.15, alignment: .center)
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
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
