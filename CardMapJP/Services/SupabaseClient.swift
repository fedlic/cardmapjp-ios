import Foundation
import Supabase

enum AppConfig {
    static let supabaseURL = URL(string: "https://cardmap.fedlic.tokyo")!
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InNlbGYtaG9zdGVkIiwiaWF0IjoxNzc0NDI3NzM0LCJleHAiOjIwODk3ODc3MzR9.gFu20BFN1tjxRKAw2MbiuUYhnlHT_0GWMTcb0lpcX6Y"
}

let supabase = SupabaseClient(
    supabaseURL: AppConfig.supabaseURL,
    supabaseKey: AppConfig.supabaseAnonKey
)
