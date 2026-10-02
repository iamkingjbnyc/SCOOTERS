$path = "C:\Users\HI\Desktop\NYCATVS\scooters.html"
$content = [System.IO.File]::ReadAllText($path)

$map = [ordered]@{
  "VIPER VTR 150cc"               = "viper-vtr-150cc"
  "Tank Pro X200 Elite"           = "tank-pro-x200-elite"
  "Tank Defender 150"             = "tank-defender-150"
  "Marchal X200 Delivery Edition" = "marchal-x200-delivery-edition"
  "Intrepid 200"                  = "intrepid-200"
  "Tank Combat 200"               = "tank-combat-200"
  "Eco 50cc"                      = "eco-50cc"
  "Magnum 50cc"                   = "magnum-50cc"
  "Milano 150"                    = "milano-150"
  "Milano 50"                     = "milano-50"
  "Denali 49cc"                   = "denali-49cc"
  "Razr 150cc"                    = "razr-150cc"
  "Razr 200cc"                    = "razr-200cc"
  "Tank Sport X200"               = "tank-sport-x200"
  "Jag 200"                       = "jag-200"
  "VTR 200"                       = "vtr-200"
  "Viper 150cc"                   = "viper-150cc"
  "Viper 49cc"                    = "viper-49cc"
  "Viper ST-50cc"                 = "viper-st-50cc"
  "Focus ST-50cc"                 = "focus-st-50cc"
  "Focus ST-150cc"                = "focus-st-150cc"
  "Tank X200 Pro"                 = "tank-x200-pro"
  "Vogue 50"                      = "vogue-50"
  "Champion 200 EFI"              = "champion-200-efi"
}

foreach ($name in $map.Keys) {
  $slug = $map[$name]
  $escaped = [regex]::Escape($name)

  # h3 cards
  $h3Pattern = "<h3>$escaped</h3>"
  $h3Replacement = "<h3><a href=`"scooters/$slug.html`" style=`"color:inherit;`">$name</a></h3>"
  $content = [regex]::Replace($content, $h3Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $h3Replacement })

  # featured h2
  $h2Pattern = '<h2 class="section-title">' + $escaped + '</h2>'
  $h2Replacement = '<h2 class="section-title"><a href="scooters/' + $slug + '.html" style="color:inherit;">' + $name + '</a></h2>'
  $content = [regex]::Replace($content, $h2Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $h2Replacement })
}
[System.IO.File]::WriteAllText($path, $content, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Linked $($map.Count) scooter headings to product pages."
