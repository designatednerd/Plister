//
//  File+Reset.swift
//  PlisterTests
//
//  Created by Ellen Shapiro on 7/7/19.
//

import Files
import ShellOut

extension File {
    
    /// Resets the caller (and ONLY the caller) to its git head.
    func resetToGitHEAD() throws {
        let cmd = ShellOutCommand(string: "git checkout HEAD -- \"\(self.path)\"")
        try shellOut(to: cmd, at: self.parent!.path)
    }
}
