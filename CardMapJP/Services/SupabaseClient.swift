import Foundation
import Supabase

enum AppConfig {
    static let supabaseURL = URL(string: "https://dlpjvbofizwxjkjqkqkv.supabase.co")!
    static let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRscGp2Ym9maXp3eGpranFrcWt2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM4MDM2NTYsImV4cCI6MjA4OTM3OTY1Nn0.1EOFVIR4UbsEBjk9bqXdyM98NP6frJqe7gozSePQQsU"
}

let supabase = SupabaseClient(
    supabaseURL: AppConfig.supabaseURL,
    supabaseKey: AppConfig.supabaseAnonKey
)
