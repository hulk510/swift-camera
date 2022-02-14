//
//  ActivityView.swift
//  carmera
//
//  Created by 後藤遥 on 2022/02/14.
//

import SwiftUI

// UIActivityViewControllerもUIViewControllerRepresentableプロトコルでラップする感じらしい。
// 対応されればやらなくても良くなるらしいけどな。
struct ActivityView: UIViewControllerRepresentable {
    // @Stateは状態変化やから途中で変わるけど多分このプロパティの設定だと
    // 最初にinitialize(引数で渡してあげるかinit関数で渡す）それか初期値を与えるってのをやらないといけない気がする。
    // count upさせるなら @State使うって感じかな
    let shareItems: [Any] // 配列の値がAnyって感じらしい。[]anyとかの方がわかりやすない？
    
    // このメソッドはViewを生成するタイミングで自動で呼び出される
    // 名前が違う畔も動くのか？それともmakeUIViewController出ないといけないのか？
    func makeUIViewController(context: Context) -> UIActivityViewController {
        // これでcontrollerインスタンスを生成して返すことでシェア画面を返せるらしい
        let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        return controller
    }
    
    // これはviewが更新されたときに実行される
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ActivityView>) {
            
        }
}
