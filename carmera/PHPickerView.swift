//
//  PHPickerView.swift
//  carmera
//
//  Created by 後藤遥 on 2022/02/14.
//

import SwiftUI
import PhotosUI

struct PHPickerView: UIViewControllerRepresentable {
    @Binding var isShowSheet: Bool
    @Binding var captureImage: UIImage?
    
    class Coordinator: NSObject,
                       PHPickerViewControllerDelegate {
        var parent: PHPickerView
        
        init(parent: PHPickerView) {
            self.parent = parent
        }
        
        // これが写真を選択・キャンセルしたときに実行されるらしい。delegateされる
        func picker(
            _ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]) {
                if let result = results.first {
                    result.itemProvider.loadObject(ofClass: UIImage.self) {
                        (image, error) in
                        if let unwrapImage = image as? UIImage {
                            self.parent.captureImage = unwrapImage
                        } else {
                            print("使える写真がないよ！")
                        }
                    }
                    parent.isShowSheet = true
                } else {
                    print("選択された写真はないよ")
                    parent.isShowSheet = false
                }
            }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PHPickerView>) ->  PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator // delegate設定
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<PHPickerView>) {
        
    }
}
