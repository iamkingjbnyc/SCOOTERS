$path = "C:\Users\HI\Desktop\NYCATVS\ebikes.html"
$content = [System.IO.File]::ReadAllText($path)

$cards = @(
  @{ Slug="rfn-e2-plus"; Name="RFN E2-Plus"; Image="rfne2plus.jpg";
     Bullets=@("Power|48V 1000W rated / 2000W peak","Top Speed|15/25/40 km/h (3 modes)","Range|18 km @ 35 km/h") },
  @{ Slug="rfn-e2-pro-max"; Name="RFN-E2 Pro Max"; Image="rfne2promax.jpg";
     Bullets=@("Power|48V 2000W rated / 5000W peak","Top Speed|30/50/70 km/h (3 modes)","Range|30 km @ 35 km/h") },
  @{ Slug="rfn-warrior-pro-e15"; Name="RFN Warrior Pro E15"; Image="rfnwarriorproe15.jpg";
     Bullets=@("Motor|15kW peak power","Battery|74V 40Ah lithium, 2960Wh","Range|60 miles") },
  @{ Slug="rfn-ares-rally-endurance-pro"; Name="RFN Ares Rally Endurance PRO"; Image="rfnaresrallypro.jpg";
     Bullets=@("Motor|12.5kW peak, energy regen","Top Speed|75 km/h (~47 mph)","Extras|CE certified, street legal") },
  @{ Slug="rfn-warrior-youth-sx-e5"; Name="RFN Warrior Youth SX-E5"; Image="rfnwarrioryouthsxe5.jpg";
     Bullets=@("Motor|5kW peak power","Range|25 miles","Built For|Youth riders") },
  @{ Slug="rfn-warrior-kids-sx-e350"; Name="RFN Warrior Kids SX-E350"; Image="rfnwarriorkidssxe350.jpg";
     Bullets=@("Motor|36V 500W","Top Speed|15/25/35 km/h (3 modes)","Built For|Kids ages 4&ndash;8") },
  @{ Slug="rfn-warrior-kids-sx-e500"; Name="RFN Warrior Kids SX-E500"; Image="rfnwarriorkidssxe500.jpg";
     Bullets=@("Motor|36V 500W","Top Speed|15/25/35 km/h (3 modes)","Built For|Kids ages 4&ndash;8") },
  @{ Slug="v8-max-dual-battery"; Name="V8 Max (Dual Battery)"; Image="v8max.jpg";
     Bullets=@("Motor|750W","Battery|48V 15Ah &times; 2 (dual)","Range|90&ndash;100 km") },
  @{ Slug="evo-20"; Name="EVO 20"; Image="evo20.jpg";
     Bullets=@("Motor|750W, electronic variator","Range|20 km","Max Load|70 kg") },
  @{ Slug="evo16"; Name="RFN EVO 16"; Image="evo16rfn.jpg";
     Bullets=@("Motor|36V 500W brushless","Top Speed|Up to 30 km/h (Sport)","Built For|Kids &amp; young riders") },
  @{ Slug="gt-s-2000"; Name="GT-S 2000"; Image="gts2000.jpg";
     Bullets=@("Motor|2000W nominal / 3000W peak","Top Speed|60 km/h (37 mph)","Range|40&ndash;100 km (25&ndash;62 mi)") }
)

$cardHtml = foreach ($c in $cards) {
  $bulletsHtml = ($c.Bullets | ForEach-Object {
    $parts = $_ -split '\|', 2
    "            <li><strong>$($parts[0]):</strong> $($parts[1])</li>"
  }) -join "`n"

@"
      <div class="bike-card">
        <a href="ebikes/$($c.Slug).html"><img src="images/$($c.Image)" alt="$($c.Name) electric bike"></a>
        <div class="bike-card-body">
          <h3><a href="ebikes/$($c.Slug).html" style="color:inherit;">$($c.Name)</a></h3>
          <p class="bike-price">Call for Pricing</p>
          <ul>
$bulletsHtml
          </ul>
          <a href="index.html#contact" class="btn btn-outline btn-block">Ask About This Bike</a>
        </div>
      </div>
"@
}

$insertion = ($cardHtml -join "`n")

$marker = "    </div>`n  </div>`n</section>`n`n<!-- ===== CTA Banner ===== -->"
if ($content -notmatch [regex]::Escape($marker)) {
  Write-Host "ERROR: marker not found"
  exit 1
}

$replacement = $insertion + "`n    </div>`n  </div>`n</section>`n`n<!-- ===== CTA Banner ===== -->"
$content = $content.Replace($marker, $replacement)

[System.IO.File]::WriteAllText($path, $content, (New-Object System.Text.UTF8Encoding($false)))
Write-Host "Added $($cards.Count) cards to ebikes.html"
