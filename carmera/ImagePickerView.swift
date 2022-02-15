//
//  ImagePickerView.swift
//  carmera
//
//  Created by 後藤遥 on 2022/02/11.
//

import SwiftUI // これインポートすると基本的にUIKitはimportされるらしい

//UIKitのdelegateを使うためにCoorinator機能を使うらしい。
// delegateは処理が完了したときに通知する仕組み

// このコード全然わからん笑
// UIImagePickerContorollerを使うことでカメラから画像を取得できる
// これを使うためにはCoordinatorを使わないとdelegateがSwiftUIでは使えない
// UIImagePickerControllerはUIKitのUIViewControllerRepresentableプロトコルを利用してアクセスするって感じ。
//
struct ImagePickerView: UIViewControllerRepresentable {
    // BindingはStateを定義したviewと違うviewで双方向にデータ連動できるらしい
    @Binding var isShowSheet: Bool
    @Binding var captureImage: UIImage?
    
    class Coordinator: NSObject,
                       UINavigationControllerDelegate,
                       UIImagePickerControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(
            // _は引数名を省略してるだから多分pickerが引数でそのあとは型やと思う。
            // 省略する意味はなんなのか？
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: // このinfoちゃんとしてないと写真取れない
            [UIImagePickerController.InfoKey : Any]) {
                
                // ここで取った写真をcaptureImageに保存
                if let originalImage = info[UIImagePickerController.InfoKey.originalImage]
                    as? UIImage {
                    parent.captureImage = originalImage
                }
                parent.isShowSheet = true
            }
        
        // delegateメソッド、キャンセル時に呼ばれる。
        // 必ず必要らしいけどなんでこれが必ず必要になるのか謎。
        func imagePickerControllerDidCancel(
            _ picker: UIImagePickerController) {
                parent.isShowSheet = false
            }
    }
    
    // Coordinatorを使うにはこれが必要らしい。
    // ほいでこれのおかげ？でmakeUIViewControllerとかのメソッドが勝手に使われるっぽい。
    func makeCoordinator() -> Coordinator {
        Coordinator(self) // selfはこの場合 -> ImagePickerView
    }
    
    // makeとupdateはシェアボタンでも使ってるがcoordinatorを使うのはdelegateを使うから
    // make, updateがいるのはUIViewControllerRepresentableで必要みたい。
    // だからどっちもこれだけは実装してる。coordinatorはやっぱりdelegate使うからか
    // っていうかこれ使うだけで勝手にしたから出てくるし、それ以外のボタンとか使わなくても勝手に出てくるってのがすごいな
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let myImagePickerController = UIImagePickerController()
        myImagePickerController.sourceType = .camera
        myImagePickerController.delegate = context.coordinator
        return myImagePickerController
    }
    
    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: UIViewControllerRepresentableContext<ImagePickerView>
    ) {
        // nothing func
    }
}
