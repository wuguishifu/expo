// Copyright 2023-present 650 Industries. All rights reserved.

import Foundation

/// Transforms background notification payloads into a format expected by the JavaScript layer.
/// see BackgroundEventTransformerSpec
public class BackgroundEventTransformer {
  public static func transform(_ data: [AnyHashable: Any]?) -> [String: Any] {
    guard let payload = data else {
      return [:]
    }
    
    var result: [String: Any] = [
      "data": payload.filter { $0.key as? String != "aps" },
      "notification": NSNull()
    ]
    
    if let aps = payload["aps"] as? [String: Any] {
      result["aps"] = aps
      result["notification"] = aps["alert"] ?? NSNull()
      if let category = aps["category"] as? String, var data = result["data"] as? [String: Any] {
        data["categoryId"] = category
        result["data"] = data
      }
    }
    
    return result
  }
}
