//
//  TaskKadai.swift
//  taskappKadai
//
//  Created by 武井康祐 on 2019/11/03.
//  Copyright © 2019 KousukeTakei. All rights reserved.
//

import RealmSwift

@objcMembers class Task: Object {
    //管理用 ID。プライマリーキー
    dynamic var id = 0
    
    dynamic var title = ""
    
    
    dynamic var contents = ""
    
    
    dynamic var date = Date()
    
    //TaskクラスにcategoryというStringプロパティを追加する
    dynamic var category = ""
    
    /**
    　idをプライマリーキーとして設定
     */
    override static func primaryKey() ->String? {
        return "id"
    }
}
