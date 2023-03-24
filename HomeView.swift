//
//  HomeView.swift
//  RecipeBot
//
//  Created by tbarnes
//


import SwiftUI
import OpenAISwift

struct HomeView: View {
    
    @ObservedObject var viewModel = ViewModel() // OpenAI APIs
    @State private var text = ""
    @State private var messages = [ChatMessage]()
    @State var isCopied = false
    
    var body: some View {
        VStack {
            HStack {
                
                HStack(spacing:2) {
                    Text("RecipeBot")
                        .font(.headline)
                        .bold()
                    Image(systemName: "frying.pan")
                        .font(.system(size: 15))
                        .foregroundColor(.orange)
                }
                Spacer()
                
                Button(action: {clearHistory()}) {
                    HStack (spacing:4){
                        Image(systemName: "trash.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                        Text("Clear")
                            .font(.caption).bold()
                            .foregroundColor(.white)
                        
                    }
                    .padding(3).padding(.horizontal)
                    .background(.orange).cornerRadius(500)
                }
            }.padding(.horizontal)
            
            ScrollView {
                ForEach(messages, id: \.id) { message in
                    
                    HStack {
                        if message.isMe {
                            HStack(alignment: .top, spacing: 6) {
                                Spacer()
                                HStack {
                                    
                                    VStack(alignment: .leading, spacing: 1) {
                                        HStack {
                                            Text("Me")
                                                .font(.caption2)
                                                .foregroundColor(.gray.opacity(0.7))
                                                .offset(x:15)
                                            
                                            // Detele message btn for me
                                            Button(action: {
                                                self.delete(message: message)
                                            }) {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 9))
                                                    .foregroundColor(.red)
                                                    .padding(3)
                                                
                                            }.offset(x:10).padding(.top, 1)
                                        }
                                        
                                        Text(message.text)
                                            .font(.body).foregroundColor(.white)
                                            .padding(10).padding(.horizontal, 4)
                                            .background(.orange).cornerRadius(20)
                                        
                                    }
                                }
                                
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.gray)
                                    .offset(x:-1, y:25)
                            }
                        } else {
                            HStack(alignment: .top, spacing: 6) {
                                Image("botpr")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(500)
                                    .offset(y:27)
                                HStack {
                                    VStack(alignment: .leading, spacing: 1) {
                                        HStack {
                                            
                                            Text("RecipeBot")
                                                .font(.caption2)
                                                .foregroundColor(.gray.opacity(0.7))
                                                .offset(x:15)
                                            
                                            // Copy button
                                            Button(action: {
                                                UIPasteboard.general.string = message.text
                                                self.isCopied = true
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                    self.isCopied = false
                                                }
                                            }) {
                                                Text(isCopied ? "Copied" : "Copy")
                                                    .font(.caption2).bold()
                                                    .foregroundColor(.orange)
                                                    .padding(.horizontal, 8).padding(1)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 200).stroke(.orange, lineWidth: 1)
                                                    )
                                            }.offset(x:13)
                                            
                                            // Clear messages
                                            Button(action: {
                                                self.delete(message: message)
                                            }) {
                                                    Image(systemName: "trash")
                                                    .font(.system(size: 9))
                                                    .foregroundColor(.red)
                                                    .padding(3)
                                                
                                            }.offset(x:10)
                                            
                                        }.offset(y:-5).padding(.top, 4)
                                        
                                        Text(message.text)
                                            .font(.body).foregroundColor(Color("text"))
                                            .padding(10).padding(.horizontal, 4)
                                            .background(.gray.opacity(0.2)).cornerRadius(20)
                                            
                                    }
                                }
                                Spacer()
                            }.padding(.top, 2)
                        }
                    }
                    .listRowSeparator(.hidden)
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
            .listStyle(.plain)
            .scrollIndicators(.hidden)
            
            VStack {
                ZStack(alignment: .trailing) {
                    TextField("Ask me anything...", text: $text)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 500).stroke(.gray.opacity(0.2), lineWidth: 1)
                        )
                    if !text.isEmpty {
                        Button(action: {
                            self.send()
                        }) {
                            ZStack {
                                ZStack {
                                    Circle()
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(.white)
                                    Image(systemName: "arrow.up.circle.fill")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(.orange)
                                }
                            }
                        }
                        .padding(4)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            retrieveData()
            viewModel.setup()
        }
    }
    
    private func send() {
        let message = ChatMessage(id: UUID(), text: text, isMe: true)
        withAnimation {
            messages.append(message)
            saveData()
        }
        
        // check for responsiveness from Chatgbt server. Wait 15 seconds then prompt failure
        var responseReceived = false
        let timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { timer in
            if !responseReceived {
                let message = ChatMessage(id: UUID(), text: "Try again please...", isMe: false)
                withAnimation {
                    self.messages.append(message)
                    self.saveData()
                }
            }
        }
        
        // TODO: clean this up
        viewModel.send(text: text) { response in
            responseReceived = true
            timer.invalidate()
            let message = ChatMessage(id: UUID(), text: ("RecipeBot:\(response)"), isMe: false)
            withAnimation {
                self.messages.append(message)
                self.saveData()
            }
        }
        
        text = ""
    }

    private func delete(message: ChatMessage) {
        messages.removeAll(where: { $0.id == message.id })
        saveData()
    }
    
    private func clearHistory() {
        messages = []
    }
    
    private func saveData() {
        let userDefaults = UserDefaults.standard
        let encodedData = try! JSONEncoder().encode(messages)
        userDefaults.set(encodedData, forKey: "messages")
        userDefaults.synchronize()
    }
    
    private func retrieveData() {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.data(forKey: "messages") {
            let decodedData = try! JSONDecoder().decode([ChatMessage].self, from: data)
            self.messages = decodedData
        }
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

