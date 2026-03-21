<div align="center">

# CardMapJP

### Find Pokemon Card Shops Across Japan

<br>

| Map | Shop List | Shop Detail |
|:---:|:---------:|:-----------:|
| Explore 284+ shops on an interactive map | Search & filter by features | AI summaries, inventory & directions |

<br>

**The ultimate Pokemon card shop finder for visitors to Japan**

Built with SwiftUI + MapKit + Supabase

---

[Web Version](https://cardmapjp.vercel.app) · [Report Bug](https://github.com/fedlic/cardmapjp-ios/issues)

</div>

## Features

- **Interactive Map** — Browse 284+ Pokemon card shops across Japan with MapKit
- **Smart Filters** — Filter by English staff, PSA graded, booster boxes, beginner-friendly, and open now
- **Shop Details** — AI-generated summaries, inventory grid, hours, payment methods
- **23 Regions** — From Akihabara to Naha, organized by prefecture
- **Nearby Shops** — GPS-powered distance sorting and walking directions
- **Google Maps Directions** — One-tap navigation to any shop

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **UI** | SwiftUI |
| **Maps** | MapKit + CoreLocation |
| **Backend** | Supabase (PostgreSQL + PostGIS) |
| **AI** | Anthropic Claude (shop summaries) |
| **Min iOS** | 17.0 |

## Getting Started

### Prerequisites

- Xcode 15+
- iOS 17.0+ device or simulator

### Setup

```bash
git clone https://github.com/fedlic/cardmapjp-ios.git
cd cardmapjp-ios
open CardMapJP.xcodeproj
```

Xcode will automatically resolve the Supabase Swift SDK dependency. Select a simulator and hit **Cmd+R**.

## Project Structure

```
CardMapJP/
├── CardMapJPApp.swift          # App entry point
├── Models/
│   ├── Shop.swift              # Shop data model + open hours logic
│   ├── Region.swift            # 23 region definitions
│   └── ShopInventory.swift     # Inventory categories & availability
├── ViewModels/
│   ├── ShopStore.swift         # Data fetching, search & filters
│   └── LocationManager.swift   # GPS location handling
├── Views/
│   ├── MainTabView.swift       # Tab bar (Map / Shops / Regions)
│   ├── MapScreen.swift         # MapKit with shop pins
│   ├── ShopListScreen.swift    # Searchable list + filter chips
│   ├── ShopDetailScreen.swift  # Full shop info + directions
│   └── RegionListScreen.swift  # Browse by region
└── Services/
    └── SupabaseClient.swift    # Supabase connection
```

## Related

- **[cardmapjp](https://github.com/fedlic/cardmapjp)** — Web version (Next.js)
- **[cardmapjp.vercel.app](https://cardmapjp.vercel.app)** — Live web app

## License

MIT
