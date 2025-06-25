//
//  MockJSON.swift
//  DemoApp
//
//  Created by Alexander on 24.06.25.
//

import Foundation

let mockJSON = """
[
  {
    "id": "abc123",
    "width": 4000,
    "height": 3000,
    "created_at": "2023-01-01T00:00:00Z",
    "description": "A beautiful blue sky",
    "likes": 123,
    "liked_by_user": true,
    "urls": {
      "raw": "https://example.com/raw.jpg",
      "full": "https://example.com/full.jpg",
      "regular": "https://example.com/regular.jpg",
      "small": "https://example.com/small.jpg",
      "thumb": "https://example.com/thumb.jpg"
    },
    "user": {
      "id": "1",
      "username": "johndoe",
      "name": "John Doe"
    }
  }
]
""".data(using: .utf8)!

let searchMockJSON = """
{
    "total": 1,
    "total_pages": 1,
    "results": [
        {
          "id": "abc123",
          "width": 4000,
          "height": 3000,
          "created_at": "2023-01-01T00:00:00Z",
          "description": "A beautiful blue sky",
          "likes": 123,
          "liked_by_user": true,
          "urls": {
            "raw": "https://example.com/raw.jpg",
            "full": "https://example.com/full.jpg",
            "regular": "https://example.com/regular.jpg",
            "small": "https://example.com/small.jpg",
            "thumb": "https://example.com/thumb.jpg"
            },
          "user": {
            "id": "1",
            "username": "johndoe",
            "name": "John Doe"
          }
        }
    ]
}
""".data(using: .utf8)!
