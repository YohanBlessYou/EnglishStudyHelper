import SwiftUI

struct MainView: View {
    @State private var showingAddingModal = false
    @State private var showingCloudActionsheet = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingProgressView = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
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
                                    Text("μμνκΈ°")
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
                                    Text("νΈμ§νκΈ°")
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
                                    Text("λ¬Έμ₯μΆκ°")
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
                                    AddingView(showingAddingModal: self.$showingAddingModal)
                                }
                            Button(
                                action: {
                                    showingCloudActionsheet = true
                                },
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
                                .confirmationDialog("", isPresented: $showingCloudActionsheet, titleVisibility: .automatic) {
                                    Button("μλ‘λ") {
                                        showingProgressView = true
                                        Task {
                                            do {
                                                try await CloudManager.shared.upload()
                                                self.alertMessage = "μλ‘λ μ±κ³΅"
                                            } catch {
                                                self.alertMessage = "μλ‘λ μ€ν¨\n\(error.localizedDescription)"
                                            }
                                            self.showingAlert = true
                                            showingProgressView = false
                                        }
                                    }
                                    Button("λ€μ΄λ‘λ") {
                                        showingProgressView = true
                                        Task {
                                            do {
                                                try await CloudManager.shared.download()
                                                self.alertMessage = "λ€μ΄λ‘λ μ±κ³΅"
                                            } catch {
                                                self.alertMessage = "λ€μ΄λ‘λ μ€ν¨\n\(error.localizedDescription)"
                                            }
                                            self.showingAlert = true
                                            showingProgressView = false
                                        }
                                    }
                                    Button("μ·¨μ", role: .cancel) {
                                        
                                    }
                                }.alert(isPresented: $showingAlert) {
                                    Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                                }
                        }.frame(width: geometry.size.width * 0.7, height: nil, alignment: .center)
                    }.frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }.background(Color(UIConfig.overallColor))
                    .navigationBarTitleDisplayMode(.inline)
                    .allowsHitTesting(!showingProgressView)
                
                if showingProgressView {
                    Spacer()
                        .background(.gray)
                        .opacity(0.3)
                    ProgressView(value: 0.0)
                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                        .scaleEffect(x: 3, y: 3, anchor: .center)
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                        .navigationBarTitle("", displayMode: .inline)
                }
            }
        }
    }
}
