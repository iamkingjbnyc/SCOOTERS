$path = "C:\Users\HI\Desktop\NYCATVS\scooters.html"
$content = [System.IO.File]::ReadAllText($path)

$map = @{
  "viper150.jpg"       = "viper-vtr-150cc"
  "tankpro200.jpg"     = "tank-pro-x200-elite"
  "tankdefender150.jpg"= "tank-defender-150"
  "marchalx200.jpg"    = "marchal-x200-delivery-edition"
  "intrepid200.jpg"    = "intrepid-200"
  "tankcombat200.jpg"  = "tank-combat-200"
  "eco50.jpg"          = "eco-50cc"
  "magnum50.jpg"       = "magnum-50cc"
  "milano150.jpg"      = "milano-150"
  "milano50.jpg"       = "milano-50"
  "denali49.jpg"       = "denali-49cc"
  "razr150.jpg"        = "razr-150cc"
  "razr200.jpg"        = "razr-200cc"
  "tanksportx200.jpg"  = "tank-sport-x200"
  "jag200.jpg"         = "jag-200"
  "vtr200.jpg"         = "vtr-200"
  "viper150b.jpg"      = "viper-150cc"
  "viper49.jpg"        = "viper-49cc"
  "viperst50.jpg"      = "viper-st-50cc"
  "focusst50.jpg"      = "focus-st-50cc"
  "focusst150.jpg"     = "focus-st-150cc"
  "tankx200pro.jpg"    = "tank-x200-pro"
  "vogue50.jpg"        = "vogue-50"
  "champion200efi.jpg" = "champion-200-efi"
}

foreach ($img in $map.Keys) {
  $slug = $map[$img]
  # Wrap <img src="images/FILE" alt="..."> with a link to the product page
  $imgPattern = '<img src="images/' + [regex]::Escape($img) + '" alt="([^"]*)">'
  $content = [regex]::Replace($content, $imgPattern, "<a href=`"scooters/$slug.html`"><img src=`"images/$img`" alt=`"`$1`"></a>")
}

[System.IO.File]::WriteAllText($path, $content, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Linked $($map.Count) scooter images to product pages."
