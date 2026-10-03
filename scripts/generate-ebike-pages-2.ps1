$root = "C:\Users\HI\Desktop\NYCATVS"
$outDir = Join-Path $root "ebikes"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$bikes = @(
  @{ Slug="rfn-e2-plus"; Name="RFN E2-Plus"; Image="rfne2plus.jpg";
     Specs=@("Power|48V 1000W rated / 2000W peak","Battery|48V 25Ah Samsung 21700 lithium &middot; ~6hr charge","Top Speed|15 / 25 / 40 km/h (3 modes)","Range|18 km @ 35 km/h","Torque|88 N&middot;m rear wheel","Tires|60/100-14 front &middot; 70/100-12 rear","Brakes|F&amp;R hydraulic disc","Suspension|Non-adjustable front &amp; rear","Weight|48 kg net &middot; 54 kg gross","Dimensions|1470 &times; 680 &times; 900mm &middot; seat height 655&ndash;695mm (adj.) &middot; wheelbase 1075mm") },
  @{ Slug="rfn-e2-pro-max"; Name="RFN-E2 Pro Max"; Image="rfne2promax.jpg";
     Specs=@("Power|48V 2000W rated / 5000W peak","Battery|48V 25Ah Samsung 21700 lithium &middot; ~6hr charge","Top Speed|30 / 50 / 70 km/h (3 modes)","Range|30 km @ 35 km/h","Torque|145 N&middot;m rear wheel","Wheels|17in front / 14in rear","Brakes|F&amp;R hydraulic disc","Suspension|Non-adjustable front &amp; rear","Weight|65 kg net &middot; 70 kg gross","Dimensions|1670 &times; 720 &times; 1000mm &middot; seat height 725&ndash;775mm (adj.) &middot; wheelbase 1135mm") },
  @{ Slug="rfn-warrior-pro-e15"; Name="RFN Warrior Pro E15"; Image="rfnwarriorproe15.jpg";
     Specs=@("Motor|15kW peak power","Battery|74V 40Ah lithium &middot; 2960Wh","Range|60 miles","Brakes|F&amp;R hydraulic disc","Suspension|Double adjustable front &middot; adjustable rear shock","Tires|70/100-19 front &middot; 90/100-16 rear","Weight|190 lbs","Seat Height|35 in &middot; Wheelbase: 53 in") },
  @{ Slug="rfn-ares-rally-endurance-pro"; Name="RFN Ares Rally Endurance PRO (Street Legal)"; Image="rfnaresrallypro.jpg";
     Specs=@("Motor|12.5kW peak, air-cooled permanent magnet synchronous, energy regen","Torque|305 N&middot;m","Top Speed|75 km/h (~47 mph)","Battery|74V 3132Wh, LG Premium 21700 cells, removable &middot; 3&ndash;4hr quick charge","Drivetrain|420 chain, 11T-58T sprockets","Suspension|Upside-down fork, 200mm travel, fully adjustable front &middot; mono-shock, 74mm travel, adjustable rear","Tires|CST CM721 70/100-19 front &middot; CST CM722 90/100-18 rear","Wheels|19in front / 18in rear, forged CNC aluminum, 20mm axle","Extras|CE certified, street legal, removable battery") },
  @{ Slug="rfn-warrior-youth-sx-e5"; Name="RFN Warrior Youth SX-E5"; Image="rfnwarrioryouthsxe5.jpg";
     Specs=@("Motor|5kW peak power","Battery|48V 25Ah lithium &middot; 1200Wh","Range|25 miles","Tires|60/100-12 front &middot; 70/100-10 rear","Brakes|F&amp;R hydraulic disc","Suspension|Double adjustable front &middot; adjustable rear","Weight|104 lbs","Seat Height|24&ndash;26 in &middot; Wheelbase: 40.5 in","Built For|Youth riders") },
  @{ Slug="rfn-warrior-kids-sx-e350"; Name="RFN Warrior Kids SX-E350"; Image="rfnwarriorkidssxe350.jpg";
     Specs=@("Motor|36V 500W","Battery|36V 7.5Ah lithium","Top Speed|15 / 25 / 35 km/h (3 modes)","Range|25 km","Tires|14in aluminum-magnesium alloy wheels","Brakes|140mm F&amp;R oil-pump disc","Suspension|Front spring fork &middot; adjustable rear shock","Weight|20 kg net &middot; 24 kg gross","Dimensions|1044 &times; 578 &times; 676mm &middot; Seat Height: 490mm","Built For|Kids ages 4&ndash;8 &middot; adjustable chest protector") },
  @{ Slug="rfn-warrior-kids-sx-e500"; Name="RFN Warrior Kids SX-E500"; Image="rfnwarriorkidssxe500.jpg";
     Specs=@("Motor|36V 500W","Battery|36V 7.5Ah lithium","Top Speed|15 / 25 / 35 km/h (3 modes)","Range|25 km","Tires|14in aluminum-magnesium alloy wheels","Brakes|140mm F&amp;R oil-pump disc","Suspension|Front spring fork &middot; adjustable rear shock","Weight|20 kg net &middot; 24 kg gross","Seat Height|490mm","Built For|Kids ages 4&ndash;8 &middot; chest protector included") },
  @{ Slug="v8-max-dual-battery"; Name="V8 Max (Dual Battery)"; Image="v8max.jpg";
     Specs=@("Motor|750W","Battery|48V 15Ah &times; 2 (dual battery)","Top Speed|50 km/h (~31 mph)","Range|90&ndash;100 km","Tires|20in wheels","Brakes|Dual disc brake","Weight|43.5 kg","Max Load|150 kg","Extras|LCD display, headlight/brake/indicator lights, rear seat") },
  @{ Slug="evo-20"; Name="EVO 20"; Image="evo20.jpg";
     Specs=@("Motor|750W, electronic variator clutch","Battery|36V 7.5Ah lithium","Range|20 km","Tires|20x2.5in alloy rims, front &amp; rear","Brakes|180mm","Suspension|648mm front &middot; 150mm rear, aluminum swingarm","Weight|22.3 kg","Max Load|70 kg &middot; Wheelbase: 1150mm","Colors|Blue / Green / Orange") },
  @{ Slug="evo16"; Name="RFN EVO 16"; Image="evo16rfn.jpg";
     Specs=@("Motor|36V 500W brushless, sine wave controller","Battery|36V 5Ah removable lithium, swappable","Top Speed|15 km/h (Eco) / 22 km/h (Low) / 30 km/h (Sport)","Range|Up to 1 hr 15 min runtime at lowest speed","Tires|16x2.5in all-terrain","Brakes|Hydraulic disc","Suspension|Dual suspension system","Frame|Aluminum","Built For|Kids &amp; young riders") },
  @{ Slug="gt-s-2000"; Name="GT-S 2000"; Image="gts2000.jpg";
     Specs=@("Motor|2000W nominal / 3000W peak","Battery|48V 32Ah (~1440Wh)","Top Speed|60 km/h (37 mph) &middot; 5 selectable modes (12.5/20/25/30/37 mph)","Range|40&ndash;100 km (25&ndash;62 mi)","Tires|24in off-road fat tires","Brakes|Dual hydraulic disc","Suspension|Front fork + mid-mount rear","Frame|High-strength alloy","Max Load|150 kg &middot; Charging: 5&ndash;6 hr","Extras|NFC keyless lock/start, LED lighting, IP45 waterproof, instant sport mode") }
)

$headerTemplate = @'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{NAME} | E-Bikes | NYC ATV Warehouse</title>
<meta name="description" content="{NAME} electric bike for sale at NYC ATV Warehouse in Little Ferry, NJ. Full specs, pricing, and availability.">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../css/style.css">
</head>
<body>

<!-- ===== Header ===== -->
<header class="site-header">
  <div class="container header-inner">
    <a href="../index.html#top" class="logo">
      <img class="logo-mark" src="../images/logo.png" alt="NYC ATV Warehouse Scooter Co.">
    </a>

    <nav class="main-nav" id="mainNav">
      <a href="../index.html#inventory">Inventory</a>
      <a href="../index.html#why-us">Why Us</a>
      <a href="../index.html#financing">Financing</a>
      <a href="../index.html#service">Service</a>
      <a href="../index.html#reviews">Reviews</a>
      <a href="../contact.html">Contact</a>
    </nav>

    <div class="header-cta">
      <div class="header-phone">
        <span>Call the warehouse</span>
        <strong><a href="tel:16469431858">646-943-1858</a></strong>
      </div>
      <a href="../contact.html" class="btn btn-primary">Get Directions</a>
      <button class="nav-toggle" id="navToggle" aria-label="Toggle menu">
        <span></span><span></span><span></span>
      </button>
    </div>
  </div>
</header>

<div class="hazard-strip"></div>

<!-- ===== Page intro ===== -->
<section>
  <div class="container">
    <div class="section-head">
      <p class="eyebrow"><a href="../ebikes.html" style="color:inherit;">E-Bikes</a> / {NAME}</p>
      <h1 class="section-title">{NAME}</h1>
    </div>
  </div>
</section>

<!-- ===== Product Detail ===== -->
<section class="section-alt">
  <div class="container split">
    <div class="split-media">
      <img id="mainPhoto" src="../images/{IMAGE}" alt="{NAME} electric bike">
    </div>
{GALLERY_BLOCK}
    <div class="split-text">
      <p class="eyebrow">E-Bike</p>
      <h2 class="section-title">{NAME}</h2>
      <p class="spec-price">Call for Pricing</p>
      <ul class="spec-list">
{SPEC_ITEMS}
      </ul>
      <a href="../contact.html" class="btn btn-primary">Ask About This Bike</a>
      <p style="margin-top:16px;"><a href="../ebikes.html" style="color:inherit;">&larr; Back to all E-Bikes</a></p>
    </div>
  </div>
</section>

<!-- ===== CTA Banner ===== -->
<div class="cta-banner">
  <div class="container">
    <h2>Don't see what you're looking for?</h2>
    <p>We get new e-bikes and scooters in weekly — call the warehouse and we'll check current stock.</p>
    <a href="tel:16469431858" class="btn btn-primary">Call 646-943-1858</a>
  </div>
</div>

<!-- ===== Footer ===== -->
<footer class="site-footer">
  <div class="container">
    <div class="footer-grid">
      <div class="footer-brand">
        <a href="../index.html#top" class="logo">
          <img class="logo-mark" src="../images/logo.png" alt="NYC ATV Warehouse Scooter Co.">
        </a>
        <p>Scooters, ATVs, dirt bikes, go-karts, UTVs and e-bikes — all under one roof in Little Ferry, NJ.</p>
        <div class="social-row">
          <a href="https://www.facebook.com/NYCATVWAREHOUSE" target="_blank" rel="noopener" aria-label="Facebook">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="currentColor"><path d="M22 12a10 10 0 10-11.6 9.9v-7H7.9V12h2.5V9.8c0-2.5 1.5-3.9 3.8-3.9 1.1 0 2.2.2 2.2.2v2.4h-1.2c-1.2 0-1.6.8-1.6 1.6V12h2.8l-.4 2.9h-2.4v7A10 10 0 0022 12z"/></svg>
          </a>
          <a href="#" aria-label="Instagram">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><rect x="3" y="3" width="18" height="18" rx="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1"/></svg>
          </a>
        </div>
      </div>

      <div class="footer-col">
        <h4>Shop</h4>
        <ul>
          <li><a href="../scooters.html">Scooters</a></li>
          <li><a href="../atvs.html">ATVs</a></li>
          <li><a href="../dirtbikes.html">Dirt Bikes</a></li>
          <li><a href="../gokarts.html">Go-Karts</a></li>
          <li><a href="../utvs.html">UTVs</a></li>
          <li><a href="../ebikes.html">E-Bikes</a></li>
        </ul>
      </div>

      <div class="footer-col">
        <h4>Company</h4>
        <ul>
          <li><a href="../index.html#why-us">Why Us</a></li>
          <li><a href="../index.html#financing">Financing</a></li>
          <li><a href="../index.html#service">Service &amp; Parts</a></li>
          <li><a href="../index.html#reviews">Reviews</a></li>
          <li><a href="../contact.html">Contact</a></li>
        </ul>
      </div>

      <div class="footer-col">
        <h4>Contact</h4>
        <ul>
          <li>207 Gates Rd<br>Little Ferry, NJ 07643</li>
          <li><a href="tel:16469431858">646-943-1858</a></li>
          <li>Mon&ndash;Fri: 10am&ndash;5pm<br>Sat&ndash;Sun: Closed</li>
        </ul>
      </div>
    </div>

    <div class="footer-bottom">
      <span>&copy; <span id="year"></span> NYC ATV Warehouse. All rights reserved.</span>
      <span>Little Ferry, NJ &middot; Serving the NYC Metro Area</span>
    </div>
  </div>
</footer>

<script src="../js/script.js"></script>
</body>
</html>
'@

foreach ($b in $bikes) {
  $specItems = ($b.Specs | ForEach-Object {
    $parts = $_ -split '\|', 2
    "        <li><strong>$($parts[0]):</strong> $($parts[1])</li>"
  }) -join "`n"

  $stem = [System.IO.Path]::GetFileNameWithoutExtension($b.Image)
  $imagesDir = Join-Path $root "images"
  $galleryFiles = @($b.Image)
  for ($i = 2; $i -le 6; $i++) {
    $candidate = "$stem-$i.jpg"
    if (Test-Path (Join-Path $imagesDir $candidate)) {
      $galleryFiles += $candidate
    }
  }

  if ($galleryFiles.Count -gt 1) {
    $thumbLines = for ($i = 0; $i -lt $galleryFiles.Count; $i++) {
      $activeClass = if ($i -eq 0) { " active" } else { "" }
      $photoNum = $i + 1
      "      <img src=`"../images/$($galleryFiles[$i])`" class=`"thumb$activeClass`" alt=`"$($b.Name) photo $photoNum`" onclick=`"document.getElementById('mainPhoto').src=this.src;document.querySelectorAll('.gallery-thumbs .thumb').forEach(function(t){t.classList.remove('active')});this.classList.add('active');`">"
    }
    $galleryBlock = "    <div class=`"gallery-thumbs`" style=`"grid-column:1;`">`n" + ($thumbLines -join "`n") + "`n    </div>"
  } else {
    $galleryBlock = ""
  }

  $page = $headerTemplate
  $page = $page.Replace("{NAME}", $b.Name)
  $page = $page.Replace("{IMAGE}", $b.Image)
  $page = $page.Replace("{SPEC_ITEMS}", $specItems)
  $page = $page.Replace("{GALLERY_BLOCK}", $galleryBlock)

  $outPath = Join-Path $outDir ($b.Slug + ".html")
  [System.IO.File]::WriteAllText($outPath, $page, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "Wrote $outPath"
}

Write-Host "Done: $($bikes.Count) pages generated."
