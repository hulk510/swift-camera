//
//  ContentView.swift
//  carmera
//
//  Created by 後藤遥 on 2022/02/11.
//

import SwiftUI

// UIImagePickerController は UIKit
// UIKit使うためにCoordinatorってやつ使うらしい

struct ContentView: View {
    
    @State var isShowSheet = false
    @State var captureImage: UIImage? = nil
    @State var isShowActivity = false
    @State var isPhotolibrary = false
    @State var isShowAction = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // captureImageがあればviewで表示する
            if let unwrapCaptureImage = captureImage {
                Image(uiImage: unwrapCaptureImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Spacer()
            
            Button(action: {
                isShowAction = true
                
            }) {
                Text("カメラを起動する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }.padding()
                .sheet(isPresented: $isShowSheet) {
                    if isPhotolibrary {
                        PHPickerView(isShowSheet: $isShowSheet,
                                     captureImage: $captureImage)
                    } else {
                        
                        ImagePickerView(
                            isShowSheet: $isShowSheet,
                            captureImage: $captureImage
                        )
                    }
                }
                .actionSheet(isPresented: $isShowAction) {
                    ActionSheet(title: Text("確認"),
                                message: Text("選択してください"),
                                buttons: [
                                    .default(Text("カメラ"), action: {
                                        isPhotolibrary = false
                                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                            print("カメラは利用できます")
                                            isShowSheet = true
                                        } else {
                                            print("カメラは利用できません")
                                        }
                                    }),
                                    .default(Text("フォトライブラリー"), action: {
                                        isPhotolibrary = true
                                        isShowSheet = true
                                    }),
                                    .cancel(),
                                ])
                }
            Button(action: {
                // これもunwrapの一つで多分変数に入れれるってことが安全に使うってことなんやろな
                // 一応型指定してるからその型が入ってるってことを証明する。
                // これgoとかでも使えそうやな。別にnil比較でも良さそうやけど？
                if let _ = captureImage {
                    isShowActivity = true
                }
            }) {
                Text("SNSに投稿する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }.padding()
                .sheet(isPresented: $isShowActivity) {
                    // shareItems: [Any]に入れるために[captureImage]になってる。
                    ActivityView(shareItems: [captureImage!])
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
