$path = "C:\Users\HI\Desktop\NYCATVS\atvs.html"
$content = [System.IO.File]::ReadAllText($path)

$imgMap = [ordered]@{
  "xwolf700long.jpg"     = "xwolf-700cc-long-version"
  "cyberroamer300.jpg"   = "cyber-roamer-300-efi"
  "maximus450l.jpg"      = "maximus-450l"
  "xwolf700short.jpg"    = "xwolf-700cc-short-version"
  "xwolf550long.png"     = "xwolf-550-long-version"
  "terminator300.jpg"    = "terminator-300cc"
  "pentorahunter200.jpg" = "pentora-hunter-200-efi"
  "cyberroamer250.jpg"   = "cyber-roamer-250-efi"
  "pentorasport250.jpg"  = "pentora-sport-250cc"
  "commander200efi.jpg"  = "commander-200cc-efi"
  "commander200.jpg"     = "commander-200cc"
  "cougarut200.jpg"      = "cougar-ut-200cc"
  "cougarsport200.png"   = "cougar-sport-200cc"
  "pentora200efi.jpg"    = "pentora-200-efi"
  "pentorasport150.jpg"  = "pentora-sport-150cc"
  "pentorairide125.jpg"  = "pentora-iride-125cc"
  "pentora125.png"       = "pentora-125cc"
  "falconx125.jpg"       = "falcon-x-125cc"
  "commander125.jpg"     = "commander-125cc"
  "blazer9125.jpg"       = "blazer-9-125cc"
  "racer125.jpg"         = "racer-125cc"
  "rider10125.jpg"       = "rider-10-125cc"
  "rider9125.jpg"        = "rider-9-125cc"
  "minicommander110.jpg" = "mini-commander-110cc"
  "rxr110.jpg"           = "rxr-110cc"
}

foreach ($img in $imgMap.Keys) {
  $slug = $imgMap[$img]
  $imgPattern = '<img src="images/' + [regex]::Escape($img) + '" alt="([^"]*)">'
  $content = [regex]::Replace($content, $imgPattern, "<a href=`"atvs/$slug.html`"><img src=`"images/$img`" alt=`"`$1`"></a>")
}

$nameMap = [ordered]@{
  "XWOLF 700cc &mdash; Long Version" = "xwolf-700cc-long-version"
  "Cyber Roamer 300 EFI"             = "cyber-roamer-300-efi"
  "Maximus 450L"                     = "maximus-450l"
  "XWOLF 700cc &ndash; Short Version"= "xwolf-700cc-short-version"
  "XWOLF 550 &ndash; Long Version"   = "xwolf-550-long-version"
  "Terminator 300cc"                 = "terminator-300cc"
  "Pentora Hunter 200 EFI"           = "pentora-hunter-200-efi"
  "Cyber Roamer 250 EFI"             = "cyber-roamer-250-efi"
  "Pentora Sport 250cc"              = "pentora-sport-250cc"
  "Commander 200cc EFI"              = "commander-200cc-efi"
  "Commander 200cc"                  = "commander-200cc"
  "Cougar UT 200cc"                  = "cougar-ut-200cc"
  "Cougar Sport 200cc"               = "cougar-sport-200cc"
  "Pentora 200 EFI"                  = "pentora-200-efi"
  "Pentora Sport 150cc"              = "pentora-sport-150cc"
  "Pentora Iride 125cc"              = "pentora-iride-125cc"
  "Pentora 125cc"                    = "pentora-125cc"
  "Falcon X 125cc"                   = "falcon-x-125cc"
  "Commander 125cc"                  = "commander-125cc"
  "Blazer 9 125cc"                   = "blazer-9-125cc"
  "Racer 125cc"                      = "racer-125cc"
  "Rider 10 &ndash; 125cc"           = "rider-10-125cc"
  "Rider 9 &ndash; 125cc"            = "rider-9-125cc"
  "Mini Commander 110cc"             = "mini-commander-110cc"
  "RXR 110cc"                        = "rxr-110cc"
}

foreach ($name in $nameMap.Keys) {
  $slug = $nameMap[$name]
  $escaped = [regex]::Escape($name)

  $h3Pattern = "<h3>$escaped</h3>"
  $h3Replacement = "<h3><a href=`"atvs/$slug.html`" style=`"color:inherit;`">$name</a></h3>"
  $content = [regex]::Replace($content, $h3Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $h3Replacement })

  $h2Pattern = '<h2 class="section-title">' + $escaped + '</h2>'
  $h2Replacement = '<h2 class="section-title"><a href="atvs/' + $slug + '.html" style="color:inherit;">' + $name + '</a></h2>'
  $content = [regex]::Replace($content, $h2Pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $h2Replacement })
}

[System.IO.File]::WriteAllText($path, $content, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Linked $($imgMap.Count) ATV images and $($nameMap.Count) headings to product pages."
