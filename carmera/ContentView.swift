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
    
    var body: some View {
        VStack {
            Spacer()
            
            if let unwrapCaptureImage = captureImage {
                Image(uiImage: unwrapCaptureImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Spacer()
            
            Button(action: {
                
                if  UIImagePickerController.isSourceTypeAvailable(.camera) {
                    print("カメラは利用できます")
                    isShowSheet = true
                } else {
                    print("カメラは利用できません")
                }
                
            }) {
                Text("カメラを起動する")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }.padding()
                .sheet(isPresented: $isShowSheet) {
                    ImagePickerView(
                    isShowSheet: $isShowSheet,
                    captureImage: $captureImage
                    )
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
