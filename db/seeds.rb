require "open-uri"

puts "Cleaning database..."
Like.delete_all
Comment.delete_all
ActivityTag.delete_all
Activity.delete_all
Tag.delete_all
Hike.delete_all
Reading.delete_all
Concert.delete_all
Other.delete_all
User.where(username: [ nil, "" ]).delete_all

puts "Seeding users..."
# Users
marcel = User.find_or_initialize_by(email: "marcel@example.com")
marcel.update!(
  username: "marcel",
  password: "password123",
  password_confirmation: "password123",
  description: "Computer engineering student in Barcelona. Creator of ActivityFeed.",
  location: "Barcelona, Spain"
)

authors_data = [
  { username: "alejandro_v", email: "alejandro@example.com", location: "Cusco, Peru", description: "Spent five years as a civil engineer, quit to take photos. Haven't looked back." },
  { username: "priya_dev",   email: "priya@example.com", location: "Bangalore, India", description: "Rails dev by day, home cook by night. I make things on the internet and occasionally food." },
  { username: "solenne_m",   email: "solenne@example.com", location: "Paris, France", description: "Freelance writer. I cover food, travel, and the occasional existential spiral." },
  { username: "luca_frames", email: "luca@example.com", location: "Milan, Italy", description: "I shoot film. Mostly Kodak, sometimes Fuji, always over-exposed." }
]

authors = authors_data.map do |u_data|
  user = User.find_or_initialize_by(email: u_data[:email])
  user.update!(
    username: u_data[:username],
    password: "password123",
    password_confirmation: "password123",
    description: u_data[:description],
    location: u_data[:location]
  )
  user
end

puts "Seeding Marcel's showcase activities..."

marcel_showcase = [
  {
    title: "Early start on the Caminito del Rey",
    body: "Left the Airbnb at 5:45 to get to the trailhead before the bus tours showed up, which was the right call. By 7am there was already a queue forming at the ticket booth. The walk itself is about 8km and most of it is pretty flat since you're on a suspended boardwalk pinned to the cliff face, but there are a couple of sections where the path narrows to maybe a metre wide with a straight drop into the Guadalhorce gorge below you. Not for anyone who freezes up at heights.<br><br>The gorge is genuinely one of the most dramatic things I've seen in Spain and I've lived here six years. The light in the morning hits the rock walls in a way that makes everything look slightly unreal, like someone turned the saturation up a notch. I stopped about halfway through at the suspension bridge and just stood there for a while watching the river below.<br><br>Practical stuff: bring water, the vending machines at the end are overpriced and you'll be thirsty. The helmet they give you at the entrance is mandatory but you never actually need it. Allow about three hours total if you walk slowly and stop for photos. Parking in Ardales is free and about a 15-minute shuttle from the northern entrance. Would absolutely do this again.",
    activityable: Hike.create!(
      trail_name: "Caminito del Rey",
      distance_km: 7.7,
      elevation_gain: 105,
      duration: "2h 50m",
      route: [ { lat: 36.934, lng: -4.814 }, { lat: 36.938, lng: -4.808 } ].to_json
    ),
    image_url: "https://picsum.photos/seed/caminito/800/600",
    tags: [ "hiking", "andalucia", "spain", "outdoors" ]
  },
  {
    title: "Finished: A Little Life by Hanya Yanagihara",
    body: "I don't really know what to write here. I finished this at about 1am on a Tuesday and then just sat in bed staring at the ceiling for twenty minutes. That doesn't happen to me with books.<br><br>This is a novel about four men who meet at a university in New England and follow them across thirty or forty years of their lives in New York. That description makes it sound manageable. It is not manageable. It is 720 pages and it is relentless in a way that I'm still not entirely sure I can recommend without a warning. The central character, Jude, carries a history of abuse that the book circles back to again and again, never gratuitously but always with this suffocating weight. Yanagihara doesn't look away, which is either a virtue or a cruelty depending on how much you can take.<br><br>I know the criticisms. It's melodramatic, the suffering is excessive, some characters exist only to orbit Jude's pain. Fine. Maybe all of that is true. But I've read a lot of literary fiction and very few books have made me feel the passage of time like this one does — the way a friendship changes across decades, how people accumulate damage, how love between people who've known each other for years becomes something almost indescribable.<br><br>I cried three times. Once quietly and twice in a way I was glad nobody was around to see. Read it if you want something that will genuinely hollow you out. Don't read it if you're already having a rough month.",
    activityable: Reading.create!(
      title: "A Little Life",
      author: "Hanya Yanagihara",
      isbn: "9780804172707",
      cover_url: "https://covers.openlibrary.org/b/id/8739161-L.jpg"
    ),
    image_url: nil,
    tags: [ "books", "reading", "fiction", "literary" ]
  },
  {
    title: "Nick Cave & the Bad Seeds at WiZink Center",
    body: "I've been putting off writing this because I don't think I'm going to do it justice. Nick Cave is 67 and he walked out onto that stage like he owned every centimetre of it. No preamble, no warm-up, just straight into 'Friendo' from Wild God and the crowd lost their minds before the first chorus landed.<br><br>The set was about two hours and leaned heavily on Wild God, which I think is the right call — it's one of the best things he's made in a decade and songs like 'Long Dark Night' and 'O Wow O Wow' hit completely differently live. He also did a run of older stuff in the middle, including 'The Mercy Seat' and 'Jubilee Street', which are the songs you go see Nick Cave for. During 'Into My Arms' he came down off the stage and walked through the crowd. The people around me looked like they were having small personal crises.<br><br>Warren Ellis was as unhinged as ever — at one point he was playing the violin with what appeared to be pure aggression — and the full band arrangement made even the quieter piano songs feel enormous in that room. The production was minimal for a venue that size, mostly dramatic back-lighting, which actually suited the material better than a big light show would have.<br><br>I went alone, which I sometimes do for concerts when I really want to pay attention, and I was glad I did. Took the metro home in a daze. Already looking up whether he's touring again next year.",
    activityable: Concert.create!(
      artist: "Nick Cave & the Bad Seeds",
      venue: "Palau Sant Jordi, Barcelona",
      date: Date.new(2025, 9, 14),
      tracklist: [ "Friendo", "Song of the Lake", "Long Dark Night", "Joy", "Jubilee Street", "The Mercy Seat", "Wild God", "O Wow O Wow (How Wonderful She Is)", "Final Rescue Attempt", "Into My Arms", "White Elephant", "Bright Horses", "Conversion" ]
    ),
    image_url: "https://picsum.photos/seed/nickcave/800/600",
    tags: [ "livemusic", "nickcave", "concert", "barcelona" ]
  },
  {
    title: "Six months of running, where I'm at",
    body: "Back in January I couldn't run 5km without stopping. I'm writing this in July and I just did 14km on Sunday without really thinking about it, so something has changed.<br><br>I started running because I kept feeling wrecked after sitting at a desk all day doing coursework. I'd tried the gym twice and hated it both times. Running seemed like the most honest form of exercise — you go, you come back, you either did it or you didn't.<br><br>The first two months were genuinely miserable. I was slow, everything ached, and I had no idea what pace I was supposed to be going. The thing that actually helped was ignoring pace entirely and just running by feel for the first few weeks. Once I stopped checking my watch every 90 seconds I started enjoying it a lot more. The Ciutadella park loop is about 3km and I've been stacking two or three laps most mornings before class.<br><br>On weekends I've been doing a longer run along the Passeig Marítim and up toward the Forum. It's flat, the sea is right there, and at 7:30am on a Sunday it's almost quiet. I listen to podcasts for the easy runs and nothing at all for the long ones, which I think is the right way round.<br><br>I have no plans to do a race. People keep asking me what I'm training for and the answer is nothing, I just like doing it now. That feels like enough.",
    activityable: Other.new,
    image_url: "https://picsum.photos/seed/running/800/600",
    tags: [ "running", "fitness", "barcelona", "habits" ]
  }
]

marcel_showcase.each_with_index do |data, index|
  activity = Activity.new(
    user: marcel,
    title: data[:title],
    body: data[:body],
    slug: data[:title].parameterize,
    activityable: data[:activityable],
    published_at: Time.current - index.days
  )

  if data[:image_url]
    begin
      file = URI.open(data[:image_url])
      activity.preview_image.attach(io: file, filename: "#{activity.slug}.jpg", content_type: "image/jpeg")
    rescue => e
      puts "Could not attach image for #{data[:title]}: #{e.message}"
    end
  end

  activity.save!

  data[:tags].each do |tag_name|
    activity.tags << Tag.find_or_create_by!(name: tag_name)
  end
end

activities_data = [
  {
    author_index: 0,
    title: "Two weeks in the Cordillera Blanca",
    body: "I came to Huaraz thinking I'd do the Santa Cruz trek and then head south. That was six weeks ago and I'm still here. The Cordillera Blanca does something to you.<br><br>Santa Cruz itself is four days and the route is well-marked, which means you'll share the trail with a lot of people in peak season. I went in early May when it was quieter and cold enough at night that I could see my breath inside the tent. The section through the Punta Union pass at 4750m is the kind of thing that reminds you why you carry a camera. Nevado Taulliraju on one side, the Alpamayo valley opening up on the other. I shot two rolls just standing there.<br><br>After the trek I hired a local guide for some day hikes above the city. The lagoon at Churup is a short but steep climb and the water is this completely implausible shade of turquoise. Llaca is a longer approach but gets you closer to the glaciers. Both are worth it if you've acclimatised properly — don't try either on your first or second day at altitude, you'll be miserable.<br><br>Huaraz itself has good food and terrible wifi, which is probably the right ratio.",
    image_url: "https://picsum.photos/seed/cordillera/800/600",
    likes_count: 0,
    activityable: Hike.create!(
      trail_name: "Santa Cruz Trek, Cordillera Blanca",
      distance_km: 48.0,
      elevation_gain: 2100,
      duration: "4 days",
      route: [ { lat: -9.060, lng: -77.612 }, { lat: -9.021, lng: -77.590 } ].to_json
    ),
    tags: [ "peru", "hiking", "andes", "photography" ]
  },
  {
    author_index: 1,
    title: "I finally shipped the side project",
    body: "Okay so I've been building this thing for about eight months and yesterday I finally pushed it live. Not because it's done — it's definitely not done — but because I was using 'it's not ready' as an excuse to keep fiddling instead of getting any actual feedback.<br><br>It's a small Rails app that helps freelancers track their billable hours across multiple clients. Nothing groundbreaking, every project management app technically does this, but the ones I've tried are either too heavy or require me to use their time tracking system which I hate. This one is exactly what I want and nothing else.<br><br>The interesting technical problem was building the invoice generation. I ended up using Prawn for PDF output after experimenting briefly with a browser-based approach and deciding the page breaks were too unpredictable. Prawn is verbose but the output is predictable, which matters for something like an invoice. Getting the VAT calculations right for different EU countries was its own rabbit hole that I don't want to talk about.<br><br>Launched yesterday. Have three users, two of whom are my friends and one of whom found it somehow via a Reddit thread. That one user I don't know makes the whole thing feel more real. Will keep chipping away at it.",
    image_url: "https://picsum.photos/seed/coding/800/600",
    likes_count: 0,
    activityable: Other.new,
    tags: [ "rails", "coding", "sideproject", "shipping" ]
  },
  {
    author_index: 2,
    title: "A week in the Lot valley and why you should go",
    body: "I've been writing about France for seven years and I keep coming back to the southwest because it rewards returning. The Lot department is one of the least visited parts of the country by international tourists and that is genuinely baffling to me.<br><br>The medieval village of Saint-Cirq-Lapopie gets all the attention — it's on the 'most beautiful villages of France' list, which means it's mobbed in July and August but worth visiting out of season. The drive along the Lot river between there and Cahors is the real prize. The road follows every bend of the river through limestone cliffs and walnut orchards and small villages where the only bar closes at 7pm.<br><br>Cahors itself has a fantastic wine that nobody outside France seems to know about. It's made from Malbec — the same grape Argentina built an entire industry around — but the Cahors version is darker and drier and doesn't get exported much, which is a shame. I drank quite a lot of it over the course of a week and regret nothing.<br><br>I stayed in a farmhouse outside Figeac and spent most mornings at the market in town and most evenings reading on the terrace. I filed one piece, answered maybe twelve emails, and walked about an hour every day. That's the pace the Lot demands and it's the right pace.",
    image_url: "https://picsum.photos/seed/lot-valley/800/600",
    likes_count: 0,
    activityable: Other.new,
    tags: [ "france", "travel", "food", "slowtravel" ]
  },
  {
    author_index: 3,
    title: "Six months shooting Portra 400",
    body: "I switched to Portra 400 at the start of the year after two years of shooting mostly Kodak Gold and Ultramax. Here's what I actually think after 40-odd rolls.<br><br>The latitude is the thing. You can overexpose Portra by two, sometimes three stops and the highlights just hold, which is not something you can say about most films. This makes it incredibly forgiving for shooting in mixed light or when you're not sure what your meter is doing. I've pulled frames from rolls that I thought were ruined and they were fine. Better than fine, actually — there's a quality to the overexposed look that I've come to prefer for portraits.<br><br>The colours are neutral-warm rather than the slightly saturated look you get from Gold 200. If you're used to the punchy greens and reds of Gold you might find Portra a bit flat at first. I did. Then I started to appreciate that it doesn't fight with the light — it just records what's there.<br><br>The price is the problem. In Milan I'm paying about €18 a roll now, which means every 36 exposures costs actual money and makes you think harder about what you're pointing the camera at. I'm not sure if that's a bug or a feature. Probably both.<br><br>Still shooting it. Probably will be next year too.",
    image_url: "https://picsum.photos/seed/portra400/800/600",
    likes_count: 0,
    activityable: Other.new,
    tags: [ "photography", "film", "analog", "kodak" ]
  },
  {
    author_index: 0,
    title: "Editors at Teatro Morlans, Barcelona",
    body: "I saw Editors for the first time in 2008 in a small venue in Lima — I was 17, there on a family trip, and someone told me there was a show I should go to. I didn't really know the band but I went, and it was one of those things that recalibrated what I thought live music could sound like. Tom Smith has one of those voices that doesn't quite belong to the present moment.<br><br>Seeing them again at Teatro Morlans was a different thing entirely. The venue is a converted theatre in Gracia, small enough that you could see the sweat on the stage monitors, and the sound is excellent. They opened with 'Papillon' which was immediately right, that synth line hitting the back of the room before the drums came in. The set moved through A Ton of Love, Smokers Outside the Hospital Doors, Munich — the songs you go to see Editors for if you were there for the early records.<br><br>The newer material is more textured and less angular than the first two albums. Some people don't like what they've become. I think they've earned the right to change. The closing run of songs was as good as anything I've seen in a theatre that size and by the end the crowd had essentially stopped being a crowd and just become one thing all moving at the same time.<br><br>I walked home along the Passeig de Sant Joan with the setlist photo-recorded on my phone and felt very lucky.",
    image_url: "https://picsum.photos/seed/editors-bcn/800/600",
    likes_count: 0,
    activityable: Concert.create!(
      artist: "Editors",
      venue: "Teatro Morlans, Barcelona",
      date: Date.new(2025, 10, 3),
      tracklist: [ "Papillon", "A Ton of Love", "Smokers Outside the Hospital Doors", "No Harm", "Munich", "Marching Orders", "Sugar", "Hallelujah (So Low)", "Blood", "Violence", "An End Has a Start", "All Sparks" ]
    ),
    tags: [ "editors", "concert", "barcelona", "indierock" ]
  }
]

activities_data.each do |data|
  activity = Activity.new(
    user: authors[data[:author_index]],
    title: data[:title],
    body: data[:body],
    slug: data[:title].parameterize,
    activityable: data[:activityable],
    likes_count: data[:likes_count],
    published_at: Time.current
  )

  begin
    file = URI.open(data[:image_url])
    activity.preview_image.attach(io: file, filename: "#{activity.slug}.jpg", content_type: "image/jpeg")
  rescue => e
    puts "Could not attach image for #{data[:title]}: #{e.message}"
  end

  activity.save!

  data[:tags].each do |tag_name|
    tag = Tag.find_or_create_by!(name: tag_name)
    activity.tags << tag
  end
end

puts "Seeding additional testing data..."
# 2 New Users
test_users_data = [
  { username: "elena_peaks", email: "elena@example.com", location: "Vancouver, Canada", description: "Trail runner and weekend mountaineer. Currently working through the Huts of the Alps, one pass at a time." },
  { username: "marcus_reads", email: "marcus@example.com", location: "London, UK", description: "I read about a book a week, mostly literary fiction and history. Also make very average sourdough." }
]

test_users = test_users_data.map do |u_data|
  user = User.find_or_initialize_by(email: u_data[:email])
  user.update!(
    username: u_data[:username],
    password: "password123",
    password_confirmation: "password123",
    description: u_data[:description],
    location: u_data[:location]
  )
  user
end

# Generate 20 Activities
20.times do |i|
  user = test_users.sample
  type = [ "Hike", "Reading", "Concert", "Other" ].sample

  case type
  when "Hike"
    hike = Hike.create!(
      trail_name: [ "Joffre Lakes Trail", "Garibaldi Lake via Rubble Creek", "Black Tusk", "Elfin Lakes Loop" ].sample,
      distance_km: rand(5.0..25.0).round(1),
      elevation_gain: rand(300..1500),
      duration: "#{rand(2..8)}h #{rand(0..59)}m",
      route: [
        { lat: 49.2827, lng: -123.1207 },
        { lat: 49.3000, lng: -123.1300 },
        { lat: 49.3200, lng: -123.1400 }
      ].to_json
    )
    activityable = hike
    title = "#{hike.trail_name} (#{i + 1})"
    body = "Did this one on a whim after a weather window opened up. #{hike.trail_name} was in better condition than I expected given how wet the last few weeks have been. The approach is #{[ 'straightforward once you find the trailhead', 'scrambly in the upper section', 'muddy for the first three kilometres and then fine', 'exposed but not technically difficult' ].sample}. Views from the top were worth the early start. Would do it again in a heartbeat."
    tags = [ "hiking", "outdoors", "bc" ]
  when "Reading"
    books = [
      { title: "The Remains of the Day", author: "Kazuo Ishiguro", isbn: "9780571258246" },
      { title: "Stoner", author: "John Williams", isbn: "9781590171998" },
      { title: "Housekeeping", author: "Marilynne Robinson", isbn: "9780312243562" },
      { title: "The Dispossessed", author: "Ursula K. Le Guin", isbn: "9780061054884" },
      { title: "Middlemarch", author: "George Eliot", isbn: "9780141439549" },
      { title: "Pachinko", author: "Min Jin Lee", isbn: "9781455563937" },
      { title: "The Overstory", author: "Richard Powers", isbn: "9780393356687" },
      { title: "Normal People", author: "Sally Rooney", isbn: "9780571334650" },
      { title: "Dept. of Speculation", author: "Jenny Offill", isbn: "9780345807823" },
      { title: "The Rings of Saturn", author: "W.G. Sebald", isbn: "9780811214131" },
      { title: "Demon Copperhead", author: "Barbara Kingsolver", isbn: "9780062942029" },
      { title: "Gilead", author: "Marilynne Robinson", isbn: "9780312424305" },
      { title: "Never Let Me Go", author: "Kazuo Ishiguro", isbn: "9781400078776" },
      { title: "Lincoln in the Bardo", author: "George Saunders", isbn: "9780812985405" },
      { title: "The Secret History", author: "Donna Tartt", isbn: "9781400031702" },
      { title: "Piranesi", author: "Susanna Clarke", isbn: "9781635575637" },
      { title: "The God of Small Things", author: "Arundhati Roy", isbn: "9780812979657" },
      { title: "A Gentleman in Moscow", author: "Amor Towles", isbn: "9780143110439" },
      { title: "This Is How You Lose the Time War", author: "Amal El-Mohtar", isbn: "9781534431010" },
      { title: "Fourth Wing", author: "Rebecca Yarros", isbn: "9781649374042" }
    ]
    book = books[i % books.length]
    reading = Reading.find_or_create_by!(title: book[:title]) do |r|
      r.author = book[:author]
      r.isbn = book[:isbn]
      r.cover_url = "https://covers.openlibrary.org/b/isbn/#{book[:isbn]}-L.jpg"
    end
    activityable = reading
    title = "Finished: #{reading.title} (#{i + 1})"
    body = "Finished this on the train back from the coast. #{reading.title} has been on my list for ages and I kept finding excuses not to start it. It was exactly as good as everyone says, which doesn't happen often. #{reading.author} does something with sentences that I can't entirely explain. The ending stayed with me for days. Going to let it settle before I write anything more considered about it."
    tags = [ "books", "reading", "fiction" ]
  when "Concert"
    concert = Concert.create!(
      artist: [ "Aldous Harding", "Lankum", "Weyes Blood", "Hand Habits", "Bonny Light Horseman" ].sample,
      venue: [ "Barbican Hall", "EartH Hackney", "Union Chapel", "St John at Hackney" ].sample,
      date: Date.current - rand(1..365).days,
      tracklist: [ "Tick Tock", "The Barrel", "Guts", "Party", "Leader of the Starry Skies", "Horizon" ]
    )
    activityable = concert
    title = "#{concert.artist} at #{concert.venue} (#{i + 1})"
    body = "Not a huge crowd but a very attentive one, which is exactly right for #{concert.artist}. The venue suited the music better than a bigger room would have. They didn't talk much between songs, just played, which I respected. Left feeling slightly wrung out in the good way."
    tags = [ "music", "concert", "london" ]
  else
    activityable = Other.new
    title = [ "First attempt at hand-rolled pasta", "Long weekend in Porto", "New desk setup, finally sorted", "Trying to learn chess at 34" ].sample.to_s + " — #{i+1}"
    body = "Nothing earth-shattering to report. Just a thing I did and wanted to write down somewhere. The process was #{[ 'more satisfying than I expected', 'harder than it looked', 'almost entirely unlike what I planned', 'exactly what I needed this week' ].sample}. Might do it again."
    tags = [ "personal", "life", "misc" ]
  end

  activity = Activity.new(
    user: user,
    title: title,
    body: body,
    activityable: activityable,
    published_at: Time.current - rand(0..30).days
  )

  begin
    img_url = "https://picsum.photos/seed/#{SecureRandom.uuid}/1200/800"
    file = URI.open(img_url)
    activity.preview_image.attach(io: file, filename: "activity_#{i}.jpg", content_type: "image/jpeg")
  rescue => e
    puts "Image error: #{e.message}"
  end

  activity.save!

  # Seed real likes from other users (limited to available users)
  other_users = (authors + test_users + [ marcel ]).reject { |u| u == user }
  num_likes = rand(0..[ other_users.size, 3 ].min)
  other_users.sample(num_likes).each do |liker|
    Like.find_or_create_by!(user: liker, activity: activity)
  end

  tags.each { |t| activity.tags << Tag.find_or_create_by!(name: t) }
end

puts "Seed completed successfully with 20 new activities!"


# Edge cases

puts "Seeding mega rich-text activity for UI and layout stress testing..."

mega_body = <<~HTML
  <p>I've been meaning to write this post for a while. It's not about one trip or one thing — it's more of a brain dump from the last year of balancing coursework, side projects, and trying to actually have a life. Bear with me if it goes long. It goes long.</p>

  <h2>On changing how I study</h2>
  <p>At the start of the year I was in three group projects simultaneously and completely unable to focus on any of them. The context switching was killing my output and, more importantly, killing my enjoyment of the actual work. I'd read enough about this problem to know the theory — deep work, monotasking, time blocking, all the usual suspects — but knowing the theory and actually restructuring your day around it when you share a flat with four people are different things.</p>

  <p>The thing that finally worked was embarrassingly simple: I stopped opening WhatsApp before noon. That's it. Two hours of uninterrupted morning work before the notifications piled up made more difference than any productivity system I've ever tried. I'm mentioning this because I used to read posts like this and feel vaguely annoyed that the solution was always something obvious. Now I am that annoying post.</p>

  <h2>What I've been reading</h2>
  <p>The last twelve months have been heavy on long fiction. I went through a phase of only reading very short books and then overcorrected completely. Some things I finished and would recommend:</p>
  <ul>
    <li><strong>The Periodic Table by Primo Levi</strong> — each chapter is named after a chemical element and loosely relates to an episode in his life. It sounds gimmicky and it is not gimmicky at all. One of the best books I read this year.</li>
    <li><strong>Outline by Rachel Cusk</strong> — barely a novel in the traditional sense. A narrator on a plane to Greece has a series of conversations. The plot is essentially nothing and the book is riveting.</li>
    <li><strong>A Gentleman in Moscow by Amor Towles</strong> — a count placed under house arrest in a Moscow hotel in 1922. This one I resisted for years because it sounded light and it is not particularly light. Genuinely moved me.</li>
  </ul>

  <blockquote style="border-left: 4px solid #d1d5db; padding-left: 1.25rem; margin: 1.5rem 0; color: #6b7280; font-style: italic;">
    "The past is never where you think you left it."<br>
    <span style="font-size: 0.875rem; font-style: normal;">— Katherine Anne Porter, from Ship of Fools</span>
  </blockquote>

  <h2>A photo from the Picos de Europa</h2>
  <p>I spent four days hiking in the Picos in September. This image is from the second morning, looking back down toward Fuente Dé from about 1800m. No filter, no editing. The light was just doing that.</p>

  <div style="margin: 2rem 0;">
    <img src="https://picsum.photos/seed/picos-europa/1200/800" alt="Mountain view" style="width: 100%; height: auto; border-radius: 6px;" />
    <p style="font-size: 0.8rem; color: #9ca3af; text-align: center; margin-top: 0.5rem;">Mirador del Cable, Picos de Europa. September 2025.</p>
  </div>

  <h2>Tools I actually use</h2>
  <p>People ask me what my setup looks like. Here's what's actually on my desk:</p>
  <ol>
    <li>A ThinkPad X1 Carbon I got secondhand that somehow still runs everything I throw at it. I keep meaning to upgrade the RAM and never do.</li>
    <li>A cheap mechanical keyboard I assembled in a hostel in Valencia one weekend. It sounds better than it has any right to.</li>
    <li>A Leuchtturm1917 notebook for thinking on paper — not lecture notes, not todos, just working stuff out when staring at a screen isn't helping.</li>
  </ol>

  <p>That's roughly it. I've gone through phases of more complex setups and always come back to less.</p>

  <h2>Some code that solved a thing</h2>
  <p>This is the query that finally stopped my N+1 problem in the activity feed. Leaving it here for my future self:</p>
  <pre style="background: #1e1e2e; color: #cdd6f4; padding: 1.25rem; border-radius: 6px; overflow-x: auto; font-family: 'Courier New', monospace; font-size: 0.875rem; line-height: 1.6;">
Activity
  .includes(:user, :tags, :preview_image_attachment)
  .where(published_at: ..Time.current)
  .order(published_at: :desc)
  .page(params[:page])
  .per(12)</pre>

  <p>Obvious in retrospect. Most things are.</p>

  <h2>Where things stand</h2>
  <p>If you made it this far: thank you, and also maybe get outside. I'm going to try to write shorter posts. I always say that.</p>
HTML

mega_activity = Activity.new(
  user: marcel,
  title: "Year in review, more or less — reading, hiking, and the inbox problem",
  body: mega_body,
  slug: "year-in-review-more-or-less",
  activityable: Other.new,
  likes_count: 0,
  published_at: Time.current
)

begin
  file = URI.open("https://picsum.photos/seed/year-review/1200/800")
  mega_activity.preview_image.attach(io: file, filename: "year-in-review.jpg", content_type: "image/jpeg")
rescue => e
  puts "Could not attach mega post preview image: #{e.message}"
end

mega_activity.save!

[ "review", "reading", "hiking", "productivity", "personal" ].each do |tag_name|
  tag = Tag.find_or_create_by!(name: tag_name)
  mega_activity.tags << tag
end

puts "Mega rich-text activity seeded successfully!"

puts "Seeding mega Concert activity for UI layout stress testing..."

concert_mega_body = <<~HTML
  <p>I've seen Godspeed You! Black Emperor four times and I'm still not sure concerts is the right word for what they do. Events, maybe. The Roundhouse show last autumn is going to take me a while to fully process, so this is an attempt to start.</p>

  <h2>The setup</h2>
  <p>They don't use screens. No projections of their faces, no scrolling setlist on the side stage, nothing that would make it feel like a conventional rock show. What they use instead are 16mm film loops — grain and light and abstracted shapes — projected over the band from somewhere behind the mixing desk. The effect is that you're watching a band play inside a film that has nothing to do with what's being played, except that somehow it always seems to have everything to do with it.</p>

  <p>Thee Silver Mt. Zion opened. I've heard them described as a spin-off but they've been operating for twenty years and have their own fully formed thing. Efrim Menuck's voice is not technically a great voice and the music is better for it.</p>

  <div style="margin: 2rem 0;">
    <img src="https://picsum.photos/seed/roundhouse/1200/800" alt="Concert lights" style="width: 100%; height: auto; border-radius: 6px;" />
    <p style="font-size: 0.8rem; color: #9ca3af; text-align: center; margin-top: 0.5rem;">The Roundhouse, London. November 2025.</p>
  </div>

  <h2>The set</h2>
  <p>They don't announce songs. You either know what you're hearing or you don't. I know most of the catalogue reasonably well and even I lost track during the longer pieces, which is part of the point. The opening drone lasted about six minutes before anything melodic appeared, which would feel indulgent from another band and felt completely necessary from them.</p>

  <p>The moment I keep returning to was about forty minutes in, during what I'm fairly sure was a section from Asunder, Sweet and Other Distress. The whole band stopped simultaneously — not a fade, a cut — and the room held its breath. Then they came back in together and the sound pressure was physical. The woman standing next to me swore under her breath and then apologised to no one.</p>
HTML

mega_concert = Concert.create!(
  artist: "Godspeed You! Black Emperor",
  venue: "The Roundhouse, London",
  date: Date.new(2025, 11, 8),
  tracklist: [
    "Undoing a Luciferian Towers",
    "Bosses Hang (three posts)",
    "Fam / Famine",
    "Anthem for No State (Pt. I)",
    "Anthem for No State (Pt. II — Coda)",
    "Peasantry or 'Light! inside of Light!'",
    "Piss Crowns Are Trebled",
    "Lambs Beneath the Killing Tree",
    "Asunder, Sweet",
    "And Other Distress",
    "Behemoth",
    "JobJobJob / Quickfire and the Dead",
    "The Sad Mafioso",
    "World Police and Friendly Fire",
    "Rockets Fall on Rocket Falls",
    "The Cowboy",
    "Gathering Storm",
    "I, Dreamt I Was An Astronaut",
    "Sleep",
    "Monheim",
    "Albanian (outro)",
    "Encore: 09-15-00",
    "Encore: Slow Riot for New Zerø Kanada"
  ]
)

activity_concert = Activity.new(
  user: authors.sample,
  title: "Godspeed You! Black Emperor at the Roundhouse — a long and unfinished attempt at writing about it",
  body: concert_mega_body,
  slug: "godspeed-roundhouse-november-2025",
  activityable: mega_concert,
  likes_count: 0,
  published_at: Time.current - 2.days
)

begin
  file = URI.open("https://picsum.photos/seed/godspeed/1200/800")
  activity_concert.preview_image.attach(io: file, filename: "godspeed-roundhouse.jpg", content_type: "image/jpeg")
rescue => e
  puts "Could not attach mega concert preview image: #{e.message}"
end

activity_concert.save!
[ "postrock", "godspeedyoublackemperor", "london", "theroundhouse", "livemusic", "setlist" ].each do |tag_name|
  tag = Tag.find_or_create_by!(name: tag_name)
  activity_concert.tags << tag
end

puts "Mega concert activity and nested Concert model seeded successfully!"

puts "Seeding sample goals for marcel..."
marcel_goals = [
  { description: "Hike 50km in total", target_value: 50.0, unit: "km", activity_type: "Hike" },
  { description: "Log 5 Concerts", target_value: 5.0, unit: "count", activity_type: "Concert" },
  { description: "Read 12 Books", target_value: 12.0, unit: "count", activity_type: "Reading" }
]

marcel_goals.each do |g_data|
  goal = marcel.goals.find_or_initialize_by(description: g_data[:description])
  goal.update!(
    target_value: g_data[:target_value],
    unit: g_data[:unit],
    activity_type: g_data[:activity_type]
  )
end

# Synchronize goals with seeded activities
marcel.goals.each(&:sync_with_activities)
puts "Goals seeded and synchronized!"
