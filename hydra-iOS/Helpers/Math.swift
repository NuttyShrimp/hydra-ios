//
//  Math.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

/*
  * Linear interpolation of the value x between a and b (inclusive) to [FEED_SPECIAL_OFFSET, FEED_MAX_PRIORITY].
 *  The following formula is used:
 * p = (x - a) * FEED_MAX_VALUE / (b - a)
 */
func priorityLerp(_ x: Int, _ a: Int, _ b: Int) -> Int {
    return min(Int((Double(x - a) * Double(GlobalConstants.Priority.FEED_MAX_PRIORITY)) / Double(b - a)), GlobalConstants.Priority.FEED_MAX_PRIORITY) + GlobalConstants.Priority.FEED_SPECIAL_OFFSET
}
