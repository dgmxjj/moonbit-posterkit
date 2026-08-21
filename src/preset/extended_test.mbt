///|
test "extended presets expose common social and print dimensions" {
  inspect(PosterPreset::open_graph().aspect_ratio_label(), content="40:21")
  inspect(PosterPreset::a4_portrait().is_portrait(), content="true")
  inspect(PosterPreset::landscape_card().is_landscape(), content="true")
  inspect(PosterPreset::portrait_card().area(), content="1080000")
}

///|
test "extended preset descriptions are stable and human readable" {
  inspect(
    PosterPreset::linkedin_landscape().describe(),
    content="linkedin-landscape 1200x627 margin=72 ratio=400:209",
  )
  inspect(all_extended_presets().length(), content="8")
}
