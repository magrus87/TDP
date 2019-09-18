//
//  Array+Extension.swift
//  perm-mkr
//
//  Created by Alexander Makarov on 30/08/2019.
//  Copyright © 2019 Pro IT Resource. All rights reserved.
//

import Foundation

extension Array {
    func subtract<S>(_ other: S?) -> S? where Element == S.Element, S: Sequence, Element: Equatable {
        guard let other = other else {
            return self as? S
        }
        
        return self.filter({ element in
            !other.contains(where: { element2 in
                return element2 == element
            })
        }) as? S
    }
}
