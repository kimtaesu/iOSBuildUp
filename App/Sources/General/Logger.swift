//
//  Logger.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import SwiftyBeaver

public let logger: SwiftyBeaver.Type = {
    let console = ConsoleDestination()
    let file = FileDestination()
    console.format = "$DHH:mm:ss.SSS$d $L $N $F :$l [$T] $M"
    $0.addDestination(console)
    $0.addDestination(file)
    return $0
}(SwiftyBeaver.self)
