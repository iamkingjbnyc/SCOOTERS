$path = "C:\Users\HI\Desktop\NYCATVS\dirtbikes.html"
$content = [System.IO.File]::ReadAllText($path)

$imgMap = [ordered]@{
  "thunder300dlx.jpg"   = "thunder-300cc-dlx"
  "db21-70.jpg"         = "db-21-70cc"
  "db25-70.jpg"         = "db-25-70cc"
  "db27-110.jpg"        = "db-27-110cc"
  "db28-110.jpg"        = "db-28-110cc"
  "db32-110.jpg"        = "db-32-110cc"
  "db38-110.jpg"        = "db-38-110cc"
  "dbx4-110.jpg"        = "db-x4-110cc"
  "dbx5-125.jpg"        = "db-x5-125cc"
  "dbx6-125.jpg"        = "db-x6-125cc"
  "dbx14-125.jpg"       = "db-x14-125cc-new-frame"
  "dbx15-125.jpg"       = "db-x15-125cc-new-frame"
  "dbx16-125.jpg"       = "db-x16-125cc-new-frame"
  "dbx18-125.jpg"       = "db-x18-125cc-new-frame"
  "dbx19-125.jpg"       = "db-x19-125cc-new-frame"
  "thundert20.jpg"      = "thunder-t20"
  "vitacciraven250xl.jpg" = "vitacci-raven-250cc-xl"
  "thunder140.jpg"      = "thunder-140"
  "thunder150.jpg"      = "thunder-150cc"
  "thunder150dlx.jpg"   = "thunder-150cc-dlx"
  "db36-250.jpg"        = "db-36-250cc"
  "thunder250.jpg"      = "thunder-250cc"
  "thunder250dlx.jpg"   = "thunder-250cc-dlx"
  "thunder300.jpg"      = "thunder-300cc"
  "rxf150.jpg"          = "rxf150-freeride"
}

foreach ($img in $imgMap.Keys) {
  $slug = $imgMap[$img]
  $imgPattern = '<img src="images/' + [regex]::Escape($img) + '" alt="([^"]*)">'
  $content = [regex]::Replace($content, $imgPattern, "<a href=`"dirtbikes/$slug.html`"><img src=`"images/$img`" alt=`"`$1`"></a>")
}

$nameMap = [ordered]@{
  "Thunder 300cc DLX"          = "thunder-300cc-dlx"
  "DB-21 70cc"                 = "db-21-70cc"
  "DB-25 70cc"                 = "db-25-70cc"
  "DB-27 110cc"                = "db-27-110cc"
  "DB-28 110cc"                = "db-28-110cc"
  "DB-32 110cc"                = "db-32-110cc"
  "DB-38 110cc"                = "db-38-110cc"
  "DB-X4 110cc"                = "db-x4-110cc"
  "DB-X5 125cc"                = "db-x5-125cc"
  "DB-X6 125cc"                = "db-x6-125cc"
  "DB-X14 125cc &ndash; New Frame" = "db-x14-125cc-new-frame"
  "DB-X15 125cc &ndash; New Frame" = "db-x15-125cc-new-frame"
  "DB-X16 125cc &ndash; New Frame" = "db-x16-125cc-new-frame"
  "DB-X18 125cc &ndash; New Frame" = "db-x18-125cc-new-frame"
  "DB-X19 125cc &ndash; New Frame" = "db-x19-125cc-new-frame"
  "Thunder T20"                = "thunder-t20"
  "Vitacci Raven 250cc XL"     = "vitacci-raven-250cc-xl"
  "Thunder 140"                = "thunder-140"
  "Thunder 150cc"              = "thunder-150cc"
  "Thunder 150cc DLX"          = "thunder-150cc-dlx"
  "DB-36 250cc"                = "db-36-250cc"
  "Thunder 250cc"              = "thunder-250cc"
  "Thunder 250cc DLX"          = "thunder-250cc-dlx"
  "Thunder 300cc"              = "thunder-300cc"
  "RXF150 Freeride"            = "rxf150-freeride"
}

foreach ($name in $nameMap.Keys) {
  $slug = $nameMap[$name]
  $escaped = [regex]::Escape($name)

  $h3Pattern = "<h3>$escaped</h3>"
  $h3Replacement = "<h3><a href=`"dirtbikes/$slug.html`" style=`"color:inherit;`">$name</a></h3>"
  $content = [regex]::Replace($content, $h3Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $h3Replacement })

  $h2Pattern = '<h2 class="section-title">' + $escaped + '</h2>'
  $h2Replacement = '<h2 class="section-title"><a href="dirtbikes/' + $slug + '.html" style="color:inherit;">' + $name + '</a></h2>'
  $content = [regex]::Replace($content, $h2Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $h2Replacement })
}

[System.IO.File]::WriteAllText($path, $content, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Linked $($imgMap.Count) dirt bike images and $($nameMap.Count) headings to product pages."
