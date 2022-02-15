//
//  EffectView.swift
//  carmera
//
//  Created by 後藤遥 on 2022/02/15.
//

import SwiftUI

struct EffectView: View {
    @Binding var isShowSheet: Bool
    let captureImage: UIImage
    
    @State var showImage: UIImage? // nilも初期値なのでエラーにはならないが上の二つは引数に指定してセットしてあげないとエラーになる。
    @State var isShowActivity = false
    
    var body: some View {
        VStack {
            Spacer()
            if let unwrapShowImage = showImage {
                Image(uiImage: unwrapShowImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Spacer()
            
            Button(action: {
                let filterName = "CIPhotoEffectInstant"
                let rotate = captureImage.imageOrientation // CIImageに変換するときに失われるから回転情報を保持しておく
                let inputImage = CIImage(image: captureImage)
                
                // guardもアンラップするためのもの
                // if let ~ はアンラップできたら実行でguard elseはアンラップできなかったら実行って感じらしい。
                // なのでアンラップできなければreturnして戻るって感じやな。
                guard let effectFilter = CIFilter(name: filterName) else {
                    return
                }
                
                effectFilter.setDefaults() // これで初期化してるみたい。いいなこのinitのやり方デフォルト値を指定することで多分initの時もやってるやろうけどデフォ血も用意しといてあげるのはいいかも。
                effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                guard let outputImage = effectFilter.outputImage else {
                    return
                }
                
                // これはフィルタ加工するための作業領域を確保するインスタンスらしい
                // 実際に来れないとcreateCGImage作れないわけやし
                let ciContext = CIContext(options: nil)
                
                // ちなみにこのcreateCGImageのreturn値がCGImage?になってるからアンラップしてるって感じっぽい。
                // func createCGImage(_ image: CIImage, from fromRect: CGRect) -> CGImage?
                guard let cgImage = ciContext.createCGImage(
                    outputImage, from: outputImage.extent)
                else {
                    return
                }
                
                showImage = UIImage(cgImage: cgImage, scale: 1.0, orientation: rotate)
            }) {
                Text("エフェクト")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
            
            Button(action: {
                isShowActivity = true
            }) {
                Text("シェア")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            // $を渡すことでstateの参照を渡せるからこんな感じにフラグとして使えるって感じみたい
            .sheet(isPresented: $isShowActivity) {
                ActivityView(shareItems: [showImage!])
            }
            .padding()
            
            Button(action: {
                isShowSheet = false
            }) {
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }
            .padding()
        }
        .onAppear {
            showImage = captureImage
        }
    }
}

struct EffectView_Previews: PreviewProvider {
    static var previews: some View {
        EffectView(
            isShowSheet: Binding.constant(true), // Binding.constantを使うことでbinding型を使える便利メソッドって感じ
            captureImage: UIImage(named: "preview_use")! // ?使ってるから!にしないといけないみたい謎。
        )
    }
}
