$root = "C:\Users\HI\Desktop\NYCATVS"
$outDir = Join-Path $root "scooters"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$scooters = @(
  @{ Slug="nevo-200"; Name="Nevo 200"; Image="nevo200.jpg";
     Specs=@("Engine|200cc class","Note|Full performance spec sheet not published online &mdash; ask in-store for complete details") },
  @{ Slug="vtr-sport-x200"; Name="VTR Sport X200"; Image="vtrx200.jpg";
     Specs=@("Engine|168.9cc, 4-stroke, air-cooled (GY6)","Power|7.5kW @ 7000 rpm &middot; 11 N&middot;m torque @ 6000 rpm","Compression Ratio|9.5:1","Transmission|Belt (CVT)","Fuel Capacity|8.3 liters","Brakes|Front &amp; rear disc","Tires|2.5MT&times;14 front &middot; 3.50MT&times;14 rear","Suspension|Inverted front shocks &middot; spring rear shock","Seat Height|820mm &middot; Wheelbase: 1300mm","Weight|110 kg wet &middot; Max Load: 250 kg","Ground Clearance|220mm","Dimensions|1720 &times; 740 &times; 1060mm") },
  @{ Slug="bullet-49cc"; Name="Bullet 49.9cc"; Image="bullet49.jpg";
     Specs=@("Engine|49.9cc, 4-stroke, single-cylinder, air-forced cool","Power|2.20kW @ 8000 rpm","Top Speed|Up to 25 mph","Dimensions|67 &times; 23 &times; 32 in &middot; Wheelbase: 1302mm","Weight|235 lbs dry &middot; 250 lbs gross","Weight Capacity|200 lbs","Brakes|Front disc &middot; rear drum","Tires|120/70-12 front &amp; rear","Battery|12V 7Ah","Starting|Electric / Kick") },
  @{ Slug="falcon-200cc"; Name="Falcon 200cc"; Image="falcon200.jpg";
     Specs=@("Engine|168cc, 4-stroke, air-cooled (GY6), EFI","Power|6.8kW @ 8000 rpm &middot; 9.6 N&middot;m torque @ 5500 rpm","Top Speed|~62 mph (100 km/h)","Fuel Consumption|2.3 L/100km","Transmission|CVT automatic","Fuel Capacity|17 liters","Brakes|Front &amp; rear disc","Tires|110/70-17 front &middot; 120/70-14 rear","Suspension|Telescopic front &middot; spring hydraulic rear","Seat Height|760mm &middot; Ground Clearance: 150mm &middot; Wheelbase: 1535mm","Dimensions|2100 &times; 730 &times; 1130mm","Weight|126 kg wet &middot; Max Load: 150 kg") },
  @{ Slug="falcon-250cc"; Name="Falcon 250cc"; Image="falcon250.jpg";
     Specs=@("Engine|250cc, single-cylinder, water-cooled","Power|11.0kW","Top Speed|~70 mph","Fuel Capacity|4.2 gallons","Brakes|Front &amp; rear disc","Tires|110/70-17 front &middot; 140/70-14 rear","Weight|342 lbs dry &middot; Max Payload: 485 lbs","Wheelbase|57 in &middot; Dimensions: 79 &times; 27 &times; 35 in","Battery|12V 9Ah","Starting|Electric") },
  @{ Slug="roma-150cc"; Name="Roma 150cc"; Image="roma150.jpg";
     Specs=@("Engine|149.6cc (LK157QMJ), 4-stroke, single-cylinder, air-forced cool","Top Speed|80 km/h (50 mph)","Starting|Electric &amp; kick start, CDI ignition","Transmission|Automatic, belt drive","Oil|10W40 &middot; Battery: 12V 7Ah","Brakes|Front &amp; rear disc","Tires|130/60-13 front &amp; rear","Weight|115 kg &middot; Max Load: 150 kg") },
  @{ Slug="rocket-150cc"; Name="Rocket 150cc"; Image="rocket150.jpg";
     Specs=@("Engine|149.6cc (LK157QMJ), 4-stroke, single-cylinder, air-forced cool","Top Speed|80 km/h (50 mph)","Starting|Electric &amp; kick start, CDI ignition","Transmission|Automatic, belt drive","Oil|10W40","Brakes|Front &amp; rear disc","Tires|130/70-12 front &amp; rear","Weight|115 kg &middot; Max Load: 150 kg","Wheelbase|1360mm &middot; Dimensions: 1930 &times; 690 &times; 1025mm") }
)

$headerTemplate = @'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{NAME_PLAIN} | Scooters | NYC ATV Warehouse</title>
<meta name="description" content="{NAME_PLAIN} scooter for sale at NYC ATV Warehouse in Little Ferry, NJ. Full specs, pricing, and availability.">
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
      <a href="../index.html#contact">Contact</a>
    </nav>

    <div class="header-cta">
      <div class="header-phone">
        <span>Call the warehouse</span>
        <strong><a href="tel:16469431858">646-943-1858</a></strong>
      </div>
      <a href="../index.html#contact" class="btn btn-primary">Get Directions</a>
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
      <p class="eyebrow"><a href="../scooters.html" style="color:inherit;">Scooters</a> / {NAME}</p>
      <h1 class="section-title">{NAME}</h1>
    </div>
  </div>
</section>

<!-- ===== Product Detail ===== -->
<section class="section-alt">
  <div class="container split">
    <div class="split-media">
      <img id="mainPhoto" src="../images/{IMAGE}" alt="{NAME} scooter">
    </div>
    <div class="gallery-thumbs" style="grid-column:1;">
{GALLERY_THUMBS}
    </div>
    <div class="split-text">
      <p class="eyebrow">Scooter</p>
      <h2 class="section-title">{NAME}</h2>
      <p class="spec-price">Call for Pricing</p>
      <ul class="spec-list">
{SPEC_ITEMS}
      </ul>
      <a href="../index.html#contact" class="btn btn-primary">Ask About This Scooter</a>
      <p style="margin-top:16px;"><a href="../scooters.html" style="color:inherit;">&larr; Back to all Scooters</a></p>
    </div>
  </div>
</section>

<!-- ===== CTA Banner ===== -->
<div class="cta-banner">
  <div class="container">
    <h2>Don't see what you're looking for?</h2>
    <p>We carry dozens of scooter models — call the warehouse and we'll check current stock and pricing.</p>
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
          <li><a href="../index.html#contact">Contact</a></li>
        </ul>
      </div>

      <div class="footer-col">
        <h4>Contact</h4>
        <ul>
          <li>207 Gates Rd<br>Little Ferry, NJ 07643</li>
          <li><a href="tel:16469431858">646-943-1858</a></li>
          <li>Mon&ndash;Sat: 9am&ndash;6pm</li>
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

foreach ($s in $scooters) {
  $specItems = ($s.Specs | ForEach-Object {
    $parts = $_ -split '\|', 2
    "        <li><strong>$($parts[0]):</strong> $($parts[1])</li>"
  }) -join "`n"

  $stem = [System.IO.Path]::GetFileNameWithoutExtension($s.Image)
  $imagesDir = Join-Path $root "images"
  $galleryFiles = @($s.Image)
  for ($i = 2; $i -le 6; $i++) {
    $candidate = "$stem-$i.jpg"
    if (Test-Path (Join-Path $imagesDir $candidate)) {
      $galleryFiles += $candidate
    }
  }

  $thumbLines = for ($i = 0; $i -lt $galleryFiles.Count; $i++) {
    $activeClass = if ($i -eq 0) { " active" } else { "" }
    $photoNum = $i + 1
    "      <img src=`"../images/$($galleryFiles[$i])`" class=`"thumb$activeClass`" alt=`"$($s.Name) photo $photoNum`" onclick=`"document.getElementById('mainPhoto').src=this.src;document.querySelectorAll('.gallery-thumbs .thumb').forEach(function(t){t.classList.remove('active')});this.classList.add('active');`">"
  }
  $galleryThumbs = $thumbLines -join "`n"

  $page = $headerTemplate
  $page = $page.Replace("{NAME_PLAIN}", $s.Name)
  $page = $page.Replace("{NAME}", $s.Name)
  $page = $page.Replace("{IMAGE}", $s.Image)
  $page = $page.Replace("{SPEC_ITEMS}", $specItems)
  $page = $page.Replace("{GALLERY_THUMBS}", $galleryThumbs)

  $outPath = Join-Path $outDir ($s.Slug + ".html")
  [System.IO.File]::WriteAllText($outPath, $page, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "Wrote $outPath"
}

Write-Host "Done: $($scooters.Count) pages generated."
