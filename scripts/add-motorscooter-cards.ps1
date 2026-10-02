$path = "C:\Users\HI\Desktop\NYCATVS\scooters.html"
$content = [System.IO.File]::ReadAllText($path)

$cards = @(
  @{ Slug="nevo-200"; Name="Nevo 200"; Image="nevo200.jpg";
     Bullets=@("Engine|200cc class","Spec sheet|Ask in-store for full details") },
  @{ Slug="vtr-sport-x200"; Name="VTR Sport X200"; Image="vtrx200.jpg";
     Bullets=@("Engine|168.9cc, 7.5kW @ 7000 rpm","Transmission|Belt (CVT)","Seat Height|820mm") },
  @{ Slug="bullet-49cc"; Name="Bullet 49.9cc"; Image="bullet49.jpg";
     Bullets=@("Engine|49.9cc, 2.20kW @ 8000 rpm","Top Speed|Up to 25 mph","Starting|Electric / Kick") },
  @{ Slug="falcon-200cc"; Name="Falcon 200cc"; Image="falcon200.jpg";
     Bullets=@("Engine|168cc GY6, EFI, 6.8kW @ 8000 rpm","Top Speed|~62 mph (100 km/h)","Fuel Capacity|17 liters") },
  @{ Slug="falcon-250cc"; Name="Falcon 250cc"; Image="falcon250.jpg";
     Bullets=@("Engine|250cc, water-cooled, 11.0kW","Top Speed|~70 mph","Starting|Electric") },
  @{ Slug="roma-150cc"; Name="Roma 150cc"; Image="roma150.jpg";
     Bullets=@("Engine|149.6cc, air-forced cool","Top Speed|80 km/h (50 mph)","Transmission|Automatic, belt drive") },
  @{ Slug="rocket-150cc"; Name="Rocket 150cc"; Image="rocket150.jpg";
     Bullets=@("Engine|149.6cc, air-forced cool","Top Speed|80 km/h (50 mph)","Transmission|Automatic, belt drive") }
)

$cardHtml = foreach ($c in $cards) {
  $bulletsHtml = ($c.Bullets | ForEach-Object {
    $parts = $_ -split '\|', 2
    "            <li><strong>$($parts[0]):</strong> $($parts[1])</li>"
  }) -join "`n"

@"
      <div class="bike-card">
        <a href="scooters/$($c.Slug).html"><img src="images/$($c.Image)" alt="$($c.Name) scooter"></a>
        <div class="bike-card-body">
          <h3><a href="scooters/$($c.Slug).html" style="color:inherit;">$($c.Name)</a></h3>
          <p class="bike-price">Call for Pricing</p>
          <ul>
$bulletsHtml
          </ul>
          <a href="index.html#contact" class="btn btn-outline btn-block">Ask About This Scooter</a>
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
Write-Host "Added $($cards.Count) cards to scooters.html"
