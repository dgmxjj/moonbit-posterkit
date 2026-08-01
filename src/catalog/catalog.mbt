///|
pub(all) struct CampaignPack {
  name : String
  description : String
  jobs : Array[@config.PosterJob]
} derive(Debug, Eq)

///|
fn content(
  eyebrow~ : String,
  title~ : String,
  subtitle~ : String,
  body~ : String,
  cta~ : String,
  footer~ : String,
  image_label~ : String,
  image_asset_id~ : String,
) -> @template.TemplateContent {
  { eyebrow, title, subtitle, body, cta, footer, image_label, image_asset_id }
}

///|
fn job(
  slug~ : String,
  template~ : String,
  preset~ : String,
  theme~ : String,
  content~ : @template.TemplateContent,
) -> @config.PosterJob {
  { slug, template, preset, theme, content }
}

///|
pub fn flatten_jobs(pack : CampaignPack) -> @config.BatchJob {
  { jobs: pack.jobs }
}

///|
pub fn hackathon_pack() -> CampaignPack {
  {
    name: "hackathon-showcase",
    description: "Square launch, story editorial, and event card assets for a MoonBit hackathon sprint.",
    jobs: [
      job(
        slug="launch-square",
        template="launch",
        preset="instagram-square",
        theme="warm-editorial",
        content=content(
          eyebrow="MoonBit Hackathon 2026",
          title="MoonBit PosterKit",
          subtitle="Data-driven poster generation DSL",
          body="Compose reusable layouts, typography, image slots, and presets with typed MoonBit APIs.",
          cta="Build once, render everywhere",
          footer="mooncakes.io / github",
          image_label="Replace Cover Art",
          image_asset_id="cover-art",
        ),
      ),
      job(
        slug="editorial-story",
        template="editorial",
        preset="social-story",
        theme="swiss-grid",
        content=content(
          eyebrow="MoonBit Hackathon 2026",
          title="Poster systems that stay programmable",
          subtitle="A reusable visual language for release covers and social campaigns.",
          body="Ship themed covers, editorial stories, and event visuals from one typed pipeline.",
          cta="Readable, repeatable, release-ready",
          footer="issue 01 / august / moonbit ecosystem",
          image_label="Replace Story Image",
          image_asset_id="story-art",
        ),
      ),
      job(
        slug="event-card",
        template="event",
        preset="instagram-square",
        theme="warm-editorial",
        content=content(
          eyebrow="MoonBit Hackathon 2026",
          title="Build Better Posters",
          subtitle="Workshop / live coding / template walkthrough",
          body="Share event details, code snippets, and social-ready visuals from one batch config.",
          cta="August 2026 / online + on-site",
          footer="Shanghai / livestream / moonbit-posterkit",
          image_label="Replace Speaker Image",
          image_asset_id="speaker-card",
        ),
      ),
    ],
  }
}

///|
pub fn social_pack() -> CampaignPack {
  {
    name: "social-pack",
    description: "Vertical stories for teasers and event promotion.",
    jobs: [
      job(
        slug="teaser-story",
        template="launch",
        preset="social-story",
        theme="swiss-grid",
        content=content(
          eyebrow="MoonBit PosterKit",
          title="Launch visuals from typed configs",
          subtitle="Create poster, story, and cover systems in MoonBit.",
          body="Drive social packs from stable templates instead of manually editing each frame.",
          cta="Batch render / swap content / keep hierarchy",
          footer="template launch / preset social-story / theme swiss-grid",
          image_label="Replace Teaser Image",
          image_asset_id="teaser-image",
        ),
      ),
      job(
        slug="event-story",
        template="event",
        preset="social-story",
        theme="swiss-grid",
        content=content(
          eyebrow="MoonBit Hackathon",
          title="From config to campaign",
          subtitle="A story-sized variant for fast event promotion.",
          body="Use the same content model for vertical stories, squares, and wide thumbnails.",
          cta="One content source / many aspect ratios",
          footer="vertical social pack / automated output",
          image_label="Replace Event Story Image",
          image_asset_id="event-story",
        ),
      ),
    ],
  }
}

///|
pub fn conference_pack() -> CampaignPack {
  {
    name: "conference-pack",
    description: "A mixed asset family for CFP, keynote, and venue updates.",
    jobs: [
      job(
        slug="cfp-square",
        template="launch",
        preset="instagram-square",
        theme="swiss-grid",
        content=content(
          eyebrow="Conference Season",
          title="Call for Papers",
          subtitle="Typed templates for speakers, workshops, and programs.",
          body="Keep hierarchy stable while swapping tracks, dates, and submission prompts.",
          cta="Submit by September 15",
          footer="cfp / workshops / lightning talks",
          image_label="Replace CFP Image",
          image_asset_id="cfp-image",
        ),
      ),
      job(
        slug="keynote-story",
        template="editorial",
        preset="social-story",
        theme="swiss-grid",
        content=content(
          eyebrow="Keynote Feature",
          title="Program systems that scale with your event",
          subtitle="Editorial layouts for headliners, themes, and seasonal recaps.",
          body="Highlight key speakers and topics without losing visual consistency.",
          cta="Lineup reveal",
          footer="conference / keynote / editorial story",
          image_label="Replace Keynote Image",
          image_asset_id="keynote-image",
        ),
      ),
      job(
        slug="venue-update",
        template="event",
        preset="instagram-square",
        theme="warm-editorial",
        content=content(
          eyebrow="Venue Update",
          title="One config, many event assets",
          subtitle="Registration / venue / livestream / city guide",
          body="Bundle operational updates into a repeatable event card system for teams.",
          cta="Updated schedule / map / registration",
          footer="venue hall b / streaming hall / city transit",
          image_label="Replace Venue Image",
          image_asset_id="venue-image",
        ),
      ),
    ],
  }
}

///|
pub fn product_launch_pack() -> CampaignPack {
  {
    name: "product-launch-pack",
    description: "A broad product release bundle spanning announcement, feature story, and webinar assets.",
    jobs: [
      job(
        slug="launch-banner",
        template="launch",
        preset="youtube-thumbnail",
        theme="swiss-grid",
        content=content(
          eyebrow="v0.1 release",
          title="Ship launch banners from MoonBit",
          subtitle="Widescreen visuals for video thumbnails and release announcements.",
          body="Render hero headlines, feature teasers, and cover art slots without re-laying every asset.",
          cta="Watch the release walkthrough",
          footer="thumbnail / feature launch / video cover",
          image_label="Replace Thumbnail Art",
          image_asset_id="thumbnail-art",
        ),
      ),
      job(
        slug="feature-story",
        template="editorial",
        preset="social-story",
        theme="warm-editorial",
        content=content(
          eyebrow="Feature Story",
          title="PosterKit introduces reusable visual systems",
          subtitle="Build and iterate release storytelling with typed inputs.",
          body="Switch from ad-hoc design files to a structured pipeline that can be tested and automated.",
          cta="Template-driven storytelling",
          footer="release notes / cover story / product highlights",
          image_label="Replace Feature Story Art",
          image_asset_id="feature-story",
        ),
      ),
      job(
        slug="webinar-card",
        template="event",
        preset="instagram-square",
        theme="swiss-grid",
        content=content(
          eyebrow="Launch Webinar",
          title="Walk through the poster pipeline live",
          subtitle="Batch config, template catalog, and CI in one session.",
          body="Use event cards to promote demos, onboarding, and release education.",
          cta="Register now / limited seats",
          footer="launch webinar / q&a / sample walkthrough",
          image_label="Replace Webinar Speaker",
          image_asset_id="webinar-speaker",
        ),
      ),
    ],
  }
}

///|
pub fn education_pack() -> CampaignPack {
  {
    name: "education-pack",
    description: "Assets for tutorials, curriculum drops, and classroom updates.",
    jobs: [
      job(
        slug="curriculum-square",
        template="launch",
        preset="instagram-square",
        theme="warm-editorial",
        content=content(
          eyebrow="Course Drop",
          title="Teach visual systems with typed examples",
          subtitle="Students can read code, templates, and rendered outputs side by side.",
          body="Package lesson visuals, worksheet covers, and class announcements in one MoonBit module.",
          cta="New lesson bundle available",
          footer="education / typed examples / reusable assets",
          image_label="Replace Curriculum Art",
          image_asset_id="curriculum-art",
        ),
      ),
      job(
        slug="lecture-story",
        template="editorial",
        preset="social-story",
        theme="swiss-grid",
        content=content(
          eyebrow="Lecture Story",
          title="Design systems as executable examples",
          subtitle="Explain hierarchy, spacing, and reuse with renderable code.",
          body="Story layouts turn code-driven templates into a teaching artifact, not just a build output.",
          cta="Lecture week 03",
          footer="visual systems / classroom / story lesson",
          image_label="Replace Lecture Image",
          image_asset_id="lecture-image",
        ),
      ),
      job(
        slug="office-hours",
        template="event",
        preset="instagram-square",
        theme="warm-editorial",
        content=content(
          eyebrow="Office Hours",
          title="Bring your template and batch config questions",
          subtitle="Mentoring / lab help / rendering clinic",
          body="Event assets keep support sessions and workshop reminders consistent across weeks.",
          cta="Fridays / 19:00 / online",
          footer="office hours / review / support",
          image_label="Replace Tutor Photo",
          image_asset_id="tutor-photo",
        ),
      ),
    ],
  }
}

///|
pub fn community_pack() -> CampaignPack {
  {
    name: "community-pack",
    description: "Community spotlights, weekly digests, and member-driven announcements.",
    jobs: [
      job(
        slug="weekly-digest",
        template="launch",
        preset="instagram-square",
        theme="swiss-grid",
        content=content(
          eyebrow="Community Weekly",
          title="What the MoonBit ecosystem shipped this week",
          subtitle="Round up packages, talks, and examples with stable layouts.",
          body="Digest cards help community maintainers summarize wins without redoing design decisions.",
          cta="Read the full roundup",
          footer="weekly digest / ecosystem / examples",
          image_label="Replace Digest Art",
          image_asset_id="digest-art",
        ),
      ),
      job(
        slug="member-story",
        template="editorial",
        preset="social-story",
        theme="warm-editorial",
        content=content(
          eyebrow="Builder Spotlight",
          title="How contributors turn templates into momentum",
          subtitle="Story assets for maintainers, talks, and open source spotlights.",
          body="Promote community stories with a reusable editorial layout that keeps typography consistent.",
          cta="Member story / spotlight / notes",
          footer="community / spotlight / august",
          image_label="Replace Member Portrait",
          image_asset_id="member-portrait",
        ),
      ),
    ],
  }
}

///|
pub fn quote_story_pack() -> CampaignPack {
  {
    name: "quote-story-pack",
    description: "Thought leadership cards, founder quotes, and speaker portraits for social campaigns.",
    jobs: [
      job(
        slug="founder-quote",
        template="quote",
        preset="instagram-square",
        theme="warm-editorial",
        content=content(
          eyebrow="Builder Quote",
          title="Design systems become momentum once they can be reused and reviewed in code.",
          subtitle="MoonBit Community",
          body="Pair structured layouts with typed content so quotes, promos, and recaps all stay consistent.",
          cta="Share the idea / keep the voice",
          footer="quote card / portrait / social square",
          image_label="Replace Founder Portrait",
          image_asset_id="founder-portrait",
        ),
      ),
      job(
        slug="speaker-portrait-story",
        template="quote",
        preset="social-story",
        theme="swiss-grid",
        content=content(
          eyebrow="Speaker Note",
          title="Templates are most useful when they survive edits, handoffs, and release pressure.",
          subtitle="Hackathon Workshop Host",
          body="Use the same content schema for square pull quotes, story slides, and event-side speaker cards.",
          cta="Story portrait / event teaser",
          footer="quote story / portrait / swipes",
          image_label="Replace Speaker Portrait",
          image_asset_id="speaker-portrait",
        ),
      ),
    ],
  }
}

///|
pub fn weekly_digest_pack() -> CampaignPack {
  {
    name: "weekly-digest-pack",
    description: "Weekly recaps, release summaries, and multi-item campaign digest assets.",
    jobs: [
      job(
        slug="release-digest-wide",
        template="digest",
        preset="youtube-thumbnail",
        theme="swiss-grid",
        content=content(
          eyebrow="Weekly Digest",
          title="What shipped in MoonBit PosterKit this week",
          subtitle="Templates, validation, and CLI output all matured together.",
          body="Summarize releases, docs, and examples with a repeatable format that teams can batch render.",
          cta="Open the changelog",
          footer="digest / release / weekly recap",
          image_label="Replace Digest Cover",
          image_asset_id="digest-cover",
        ),
      ),
      job(
        slug="feature-digest-square",
        template="digest",
        preset="instagram-square",
        theme="warm-editorial",
        content=content(
          eyebrow="Feature Digest",
          title="One content source, many aspect ratios",
          subtitle="Square and wide digest cards can share the same structure.",
          body="Turn summary-heavy announcements into reusable visual blocks that still read clearly at a glance.",
          cta="Read the recap",
          footer="feature digest / square card / release notes",
          image_label="Replace Feature Digest Art",
          image_asset_id="feature-digest-art",
        ),
      ),
      job(
        slug="community-digest-story",
        template="digest",
        preset="social-story",
        theme="swiss-grid",
        content=content(
          eyebrow="Community Digest",
          title="Ecosystem highlights, talks, and maintainers in one visual summary",
          subtitle="Story-sized weekly roundups for maintainers and community editors.",
          body="Batch render digest slides for stories, recap threads, and event newsletters from the same typed data.",
          cta="Swipe the highlights",
          footer="story digest / ecosystem / roundup",
          image_label="Replace Community Digest Art",
          image_asset_id="community-digest-art",
        ),
      ),
    ],
  }
}

///|
pub fn release_notes_pack() -> CampaignPack {
  {
    name: "release-notes-pack",
    description: "A release-note oriented set that mixes thumbnails, social squares, and event reminders.",
    jobs: [
      job(
        slug="release-thumbnail",
        template="launch",
        preset="youtube-thumbnail",
        theme="warm-editorial",
        content=content(
          eyebrow="Release Notes",
          title="What changed in MoonBit PosterKit",
          subtitle="Thumbnail-first visuals for changelogs and walkthrough videos.",
          body="Highlight the biggest additions, template updates, and rendering improvements for each release.",
          cta="Watch the changelog",
          footer="release notes / walkthrough / thumbnail",
          image_label="Replace Release Thumbnail",
          image_asset_id="release-thumb",
        ),
      ),
      job(
        slug="release-square",
        template="launch",
        preset="instagram-square",
        theme="swiss-grid",
        content=content(
          eyebrow="Version 0.1.0",
          title="Built-in templates, config batches, and CLI output",
          subtitle="A square announcement asset for social timelines.",
          body="Keep release communication aligned across channels with template-aware composition.",
          cta="Read the changelog",
          footer="v0.1.0 / release / social",
          image_label="Replace Release Art",
          image_asset_id="release-art",
        ),
      ),
      job(
        slug="release-demo-event",
        template="event",
        preset="instagram-square",
        theme="swiss-grid",
        content=content(
          eyebrow="Live Demo",
          title="See the new batch renderer in action",
          subtitle="Demo / Q&A / roadmap",
          body="Promote release sessions and roadmap talks with the same event layout used for workshops.",
          cta="Thursday / 20:00 / live",
          footer="demo stream / release week / roadmap",
          image_label="Replace Release Speaker",
          image_asset_id="release-speaker",
        ),
      ),
    ],
  }
}

///|
pub fn all_packs() -> Array[CampaignPack] {
  [
    hackathon_pack(),
    social_pack(),
    conference_pack(),
    product_launch_pack(),
    education_pack(),
    community_pack(),
    quote_story_pack(),
    weekly_digest_pack(),
    release_notes_pack(),
  ]
}
