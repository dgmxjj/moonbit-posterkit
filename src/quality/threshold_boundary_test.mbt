///|
test "quality grade boundary regression 001" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 002" {
  let score = 1
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 003" {
  let score = 49
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 004" {
  let score = 50
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 005" {
  let score = 74
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 006" {
  let score = 75
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 007" {
  let score = 89
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 008" {
  let score = 90
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 009" {
  let score = 100
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 010" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 011" {
  let score = 1
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 012" {
  let score = 49
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 013" {
  let score = 50
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 014" {
  let score = 74
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 015" {
  let score = 75
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 016" {
  let score = 89
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 017" {
  let score = 90
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 018" {
  let score = 100
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 019" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 020" {
  let score = 1
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 021" {
  let score = 49
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 022" {
  let score = 50
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 023" {
  let score = 74
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 024" {
  let score = 75
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 025" {
  let score = 89
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 026" {
  let score = 90
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 027" {
  let score = 100
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 028" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 029" {
  let score = 1
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 030" {
  let score = 49
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 031" {
  let score = 50
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 032" {
  let score = 74
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 033" {
  let score = 75
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 034" {
  let score = 89
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 035" {
  let score = 90
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 036" {
  let score = 100
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 037" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 038" {
  let score = 1
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 039" {
  let score = 49
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 040" {
  let score = 50
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 041" {
  let score = 74
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 042" {
  let score = 75
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 043" {
  let score = 89
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 044" {
  let score = 90
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 045" {
  let score = 100
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 046" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 047" {
  let score = 1
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 048" {
  let score = 49
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 049" {
  let score = 50
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 050" {
  let score = 74
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 051" {
  let score = 75
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 052" {
  let score = 89
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 053" {
  let score = 90
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 054" {
  let score = 100
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 055" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 056" {
  let score = 1
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 057" {
  let score = 49
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 058" {
  let score = 50
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 059" {
  let score = 74
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 060" {
  let score = 75
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 061" {
  let score = 89
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 062" {
  let score = 90
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 063" {
  let score = 100
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 064" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 065" {
  let score = 1
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 066" {
  let score = 49
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 067" {
  let score = 50
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 068" {
  let score = 74
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 069" {
  let score = 75
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 070" {
  let score = 89
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 071" {
  let score = 90
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 072" {
  let score = 100
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 073" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 074" {
  let score = 1
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 075" {
  let score = 49
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 076" {
  let score = 50
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 077" {
  let score = 74
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 078" {
  let score = 75
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 079" {
  let score = 89
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 080" {
  let score = 90
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 081" {
  let score = 100
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 082" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 083" {
  let score = 1
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 084" {
  let score = 49
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 085" {
  let score = 50
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 086" {
  let score = 74
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 087" {
  let score = 75
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 088" {
  let score = 89
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 089" {
  let score = 90
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 090" {
  let score = 100
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 091" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 092" {
  let score = 1
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 093" {
  let score = 49
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 094" {
  let score = 50
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 095" {
  let score = 74
  let grade = grade_for(score)
  inspect(grade_text(grade), content="review")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 096" {
  let score = 75
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 097" {
  let score = 89
  let grade = grade_for(score)
  inspect(grade_text(grade), content="good")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 098" {
  let score = 90
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 099" {
  let score = 100
  let grade = grade_for(score)
  inspect(grade_text(grade), content="excellent")
  inspect(score >= 0 && score <= 100, content="true")
}

///|
test "quality grade boundary regression 100" {
  let score = 0
  let grade = grade_for(score)
  inspect(grade_text(grade), content="reject")
  inspect(score >= 0 && score <= 100, content="true")
}
