function Link-Page($path, $imgMap, $nameMap, $dir) {
  $content = [System.IO.File]::ReadAllText($path)

  foreach ($img in $imgMap.Keys) {
    $slug = $imgMap[$img]
    $imgPattern = '<img src="images/' + [regex]::Escape($img) + '" alt="([^"]*)">'
    $content = [regex]::Replace($content, $imgPattern, "<a href=`"$dir/$slug.html`"><img src=`"images/$img`" alt=`"`$1`"></a>")
  }

  foreach ($name in $nameMap.Keys) {
    $slug = $nameMap[$name]
    $escaped = [regex]::Escape($name)

    $h3Pattern = "<h3>$escaped</h3>"
    $h3Replacement = "<h3><a href=`"$dir/$slug.html`" style=`"color:inherit;`">$name</a></h3>"
    $content = [regex]::Replace($content, $h3Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $h3Replacement })

    $h2Pattern = '<h2 class="section-title">' + $escaped + '</h2>'
    $h2Replacement = '<h2 class="section-title"><a href="' + $dir + '/' + $slug + '.html" style="color:inherit;">' + $name + '</a></h2>'
    $content = [regex]::Replace($content, $h2Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $h2Replacement })
  }

  [System.IO.File]::WriteAllText($path, $content, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "Linked $path"
}

# Go-Karts
Link-Page "C:\Users\HI\Desktop\NYCATVS\gokarts.html" `
  ([ordered]@{ "trex125.jpg" = "t-rex-125cc"; "jaguar200efi.jpg" = "jaguar-200-efi" }) `
  ([ordered]@{ "T-Rex 125cc" = "t-rex-125cc"; "Jaguar 200 EFI" = "jaguar-200-efi" }) `
  "gokarts"

# UTVs
Link-Page "C:\Users\HI\Desktop\NYCATVS\utvs.html" `
  ([ordered]@{ "crossfire200.jpg" = "cross-fire-200-efi"; "rover200.jpg" = "rover-200-efi" }) `
  ([ordered]@{ "Cross Fire 200 EFI" = "cross-fire-200-efi"; "Rover 200 EFI" = "rover-200-efi" }) `
  "utvs"

# E-Bikes
Link-Page "C:\Users\HI\Desktop\NYCATVS\ebikes.html" `
  ([ordered]@{
    "gt2000.jfif"  = "ouxi-gt-2000"
    "SPARK48V.jfif" = "spark-48v"
    "OUXIV8.jfif"  = "ouxi-v8"
    "GT06.jfif"    = "gt06-e-scooter"
    "evo18.jfif"   = "rfn-evo-18"
  }) `
  ([ordered]@{
    "OUXI GT-2000"   = "ouxi-gt-2000"
    "SPARK 48V"      = "spark-48v"
    "OUXI V8"        = "ouxi-v8"
    "GT06 E-Scooter" = "gt06-e-scooter"
    "RFN EVO 18"     = "rfn-evo-18"
  }) `
  "ebikes"
