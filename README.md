# ActivityFeed

ActivityFeed is a portfolio project that I built while learning Ruby on Rails. It is a social activity journal where people can publish experiences, follow other users, and interact with a feed of hikes, book reviews, concerts, and other types of activities.


---

<p align="center">
<img width="1508" height="758" alt="Main feed: likes, comments and tag filtering" width="720" src="https://github.com/user-attachments/assets/69c79d5b-6783-45ac-b7c9-d959390bb55f" />
</p>



## What you can do?

- **Publish**, **edit** and **delete** four activity types: **Hikes**, **Readings**, **Concerts**, and **Other updates**, each its own rich-text post with a cover image and tags.
- **Browse** a paginated activity feed by title or tag search.
- **Follow** users, like activities, and add or remove comments.
- **Track** activity-based goals that automatically recalculate progress. Ex: Hike goals can track total distance in kilometres.
- Upload **GPX** files to calculate hike distance, elevation gain, and duration, then display the recorded route on a Leaflet map.
- **Search** book metadata through the Open Library API.
- **Search** artists and setlist information for concerts through the Setlist.fm API when an API key is configured.
- Use friendly, history-aware URLs so renamed activities **retain redirects** from their previous slug.
- Switch between **light and dark themes**. The selected theme is stored in the browser.


## Screenshots and Demos

### Hike Post Details
<img width="1672" alt="hike_post" src="https://github.com/user-attachments/assets/dbd91052-ef2d-4a6b-8817-85663541c736" />

Published post view showing rich text and custom hike data, including uploaded path visualization.

---

### Dark and light Mode
<img width="1685" alt="toggle_dark_mode" src="https://github.com/user-attachments/assets/676e9163-e467-4280-a186-e43540169a98" />

Dynamic dark and light theme toggling with smooth transitions.

---

<img width="1508" height="758" alt="Peek 2026-10-28 00-02" src="https://github.com/user-attachments/assets/b289ab42-da0b-4030-987b-bd423e5f4c40" />

Create a new reading post using the open library API service to fetch cover, author, title and ISBN.

---

### Main feed and profile interaction

<p align="center">
<img width="1508" height="758" alt="Main feed: likes, comments and tag filtering" width="720" src="https://github.com/user-attachments/assets/69c79d5b-6783-45ac-b7c9-d959390bb55f" />
</p>

Interactive main feed supporting likes, comments, and tag-based filtering. Profile also displays goals, short description and profile pictures for customization.


## Project Status

ActivityFeed is a learning and portfolio project. The implemented activity types are complete enough to demonstrate the core workflows. Restaurant, trip, artwork, and recipe activity types are ideas currently kept as part of the project roadmap rather than completed features.

## Tech Stack

- Ruby 3.4.9 and Rails 8.1
- SQLite for local development and test data
- Devise for authentication
- Hotwire: Turbo and Stimulus
- Action Text and Active Storage for rich content and uploads
- Pagy for pagination
- FriendlyId for readable URLs and slug history
- Faraday for API clients
- Leaflet for hike-route maps
- Minitest, WebMock, RuboCop, Brakeman, and Bundler Audit for quality checks
- Docker and Kamal configuration are included for deployment experimentation

## Local Setup

### Requirements

- Ruby 3.4.9
- Bundler
- SQLite

Clone the repository and run:

```bash
bin/setup --skip-server
bin/rails db:seed
bin/rails server
```

Then open `http://localhost:3000`.

`db:seed` resets and populates the local development data with sample users, activities, tags, goals, and demo media. Run it only against a local development database. Some sample images are downloaded during seeding, so an internet connection improves the demo experience.

### Demo Account

After seeding, the sign-in screen includes a one-click demo account. The same account can also be used directly:

```text
Email: marcel@example.com
Password: password123
```

These credentials exist only for the local seeded demo data and are not intended for a deployed application.

### Optional Setlist.fm Configuration

Concert creation works without an API key, but artist and setlist search requires a Setlist.fm key. Add it to Rails credentials:

```bash
bin/rails credentials:edit
```

```yaml
setlist_fm:
  api_key: your_api_key
```

Open Library search does not require a project API key.

## Quality Checks

Run the test suite and static checks locally with:

```bash
bin/rails test
bin/rubocop
bin/brakeman --quiet --no-pager
bin/bundler-audit check --no-update
```

The repository also includes a GitHub Actions workflow for tests, linting, and security checks.

## Architecture Notes

Activities use Rails delegated types: each `Activity` owns shared social and content behavior, while `Hike`, `Reading`, `Concert`, and `Other` store type-specific data. This keeps shared features such as tags, images, likes, comments, slugs, and ownership in one place while allowing each activity type to evolve independently.

The feed preloads its associations to avoid common N+1 query issues, and counter caches keep like, comment, follower, and following counts inexpensive to display.

## Future improvements

- Restaurant, trip, artwork, and recipe activity types
- Broader system-test coverage
- A hosted public demo

## External Services

- [Open Library](https://openlibrary.org/) for book search
- [Setlist.fm](https://www.setlist.fm/) for artist and setlist search
- [Leaflet](https://leafletjs.com/) for map rendering
