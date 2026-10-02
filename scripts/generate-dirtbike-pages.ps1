$root = "C:\Users\HI\Desktop\NYCATVS"
$outDir = Join-Path $root "dirtbikes"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$bikes = @(
  @{ Slug="thunder-300cc-dlx"; Name="Thunder 300cc DLX"; Image="thunder300dlx.jpg";
     Specs=@("Engine|271.3cc, single-cylinder, air-cooled, oblique OHC","Power|16kW @ 8500 rpm","Top Speed|100+ km/h","Starting|Electric &amp; kick start","Drive|520H-110 chain","Brakes|Hydraulic disc, 270mm front &middot; 240mm rear","Tires|80/100-21 front &middot; 100/90-18 rear","Suspension|880mm double-adjustable front fork, 265mm travel &middot; 450mm single-adjustable rear shock, 72mm travel","Seat Height|945mm","Wheelbase|1367mm &middot; Ground Clearance: 340mm","Weight|111 kg net &middot; 129 kg gross","Max Load|90 kg","Extras|Stainless steel muffler, waterproof wiring harness, aluminum handlebar") },
  @{ Slug="db-21-70cc"; Name="DB-21 70cc"; Image="db21-70.jpg";
     Specs=@("Engine|70cc, 4-stroke, air-cooled","Power|4.8kW (6.5 HP)","Starting|Kick start","Transmission|Semi-automatic, 4-speed","Brakes|Front &amp; rear drum","Suspension|Hydraulic front forks &middot; spring-over-coil rear shock","Tires|2.5-10 front &amp; rear","Seat Height|25 in &middot; Wheelbase: 930mm","Weight|65 kg gross &middot; 52 kg net","Fuel Capacity|3.7 liters","Frame|Single-tube high-strength steel") },
  @{ Slug="db-25-70cc"; Name="DB-25 70cc"; Image="db25-70.jpg";
     Specs=@("Engine|70cc (1P47FMD), 4-stroke, single-cylinder, air-cooled","Power|4.5kW (6 HP) &middot; 9.0 N&middot;m torque @ 5500 rpm","Starting|Electric start, CDI ignition","Transmission|Automatic","Brakes|Drum front (hand) &middot; drum rear (foot)","Tires|2.50-10 front &amp; rear","Seat Height|25 in &middot; Wheelbase: 36.61 in (930mm)","Ground Clearance|5.79 in (147mm)","Weight|180.4 lbs gross &middot; 149.6 lbs net","Max Load|132 lbs (60 kg)","Fuel Capacity|3 liters") },
  @{ Slug="db-27-110cc"; Name="DB-27 110cc"; Image="db27-110.jpg";
     Specs=@("Engine|110cc, 4-stroke, air-cooled","Power|6.5kW (8.7 HP)","Starting|Kick start","Transmission|Semi-automatic, 4-speed","Brakes|Front &amp; rear disc","Suspension|Hydraulic front forks &middot; spring-over-coil rear shock","Wheels|12in front &middot; 10in rear","Seat Height|25 in &middot; Wheelbase: 930mm","Weight|65 kg gross &middot; 52 kg net","Fuel Capacity|3.7 liters","Frame|Single-tube high-strength steel") },
  @{ Slug="db-28-110cc"; Name="DB-28 110cc"; Image="db28-110.jpg";
     Specs=@("Engine|110cc, air-cooled, CDI ignition","Power|6.5kW (8.7 HP)","Starting|Electric start","Transmission|Automatic, chain drive","Brakes|Front disc (hand) &middot; rear disc (foot)","Wheels|12in front &middot; 10in rear","Seat Height|25 in","Dimensions|57.48 &times; 20.47 &times; 32.68 in (1460 &times; 520 &times; 830mm)","Ground Clearance|5.79 in (147mm)","Weight|180.4 lbs gross &middot; 149.6 lbs net (82/68 kg)","Max Load|132 lbs (60 kg)","Fuel Capacity|3 liters") },
  @{ Slug="db-32-110cc"; Name="DB-32 110cc"; Image="db32-110.jpg";
     Specs=@("Engine|110cc, 4-stroke, air-cooled","Power|6.5kW (8.7 HP)","Starting|Kick start","Transmission|4-speed semi-automatic","Brakes|Front &amp; rear hydraulic disc","Suspension|Hydraulic front forks &middot; non-adjustable 320mm rear","Tires|2.5-14 front &middot; 3-12 rear","Seat Height|30 in &middot; Wheelbase: 1200mm","Weight|79 kg gross &middot; 64 kg net","Fuel Capacity|3.7 liters","Frame|Single-tube high-strength steel") },
  @{ Slug="db-38-110cc"; Name="DB-38 110cc"; Image="db38-110.jpg";
     Specs=@("Engine|110cc, air-cooled, fully automatic (FH brand)","Power|6.7 HP @ 7500 rpm &middot; 7.2 N&middot;m torque @ 7500 rpm","Starting|Electric start, CDI ignition","Transmission|Fully automatic, chain drive","Brakes|Front &amp; rear hydraulic disc","Tires|60/100-14 front &middot; 80/100-12 rear","Suspension|320mm front &middot; 260mm rear, non-adjustable","Seat Height|30 in &middot; Ground Clearance: 8 in","Weight|142 lbs net &middot; 160 lbs gross","Fuel Capacity|0.85 gallons","Frame|Single-beam heavy-duty steel") },
  @{ Slug="db-x4-110cc"; Name="DB-X4 110cc"; Image="dbx4-110.jpg";
     Specs=@("Engine|110cc, 4-stroke, air-cooled","Power|6.5kW (8.7 HP)","Starting|Kick start","Transmission|4-speed semi-automatic","Brakes|Front &amp; rear hydraulic disc","Suspension|Hydraulic front forks &middot; non-adjustable 320mm rear","Tires|2.5-14 front &middot; 3-12 rear","Seat Height|30 in","Weight|79 kg gross &middot; 64 kg net","Fuel Capacity|3.7 liters","Frame|Single-tube high-strength steel") },
  @{ Slug="db-x5-125cc"; Name="DB-X5 125cc"; Image="dbx5-125.jpg";
     Specs=@("Engine|125cc, 4-stroke, air-cooled","Power|10.0kW @ 9500 rpm","Starting|Kick start","Transmission|4-speed manual clutch","Brakes|Front &amp; rear hydraulic disc","Suspension|Non-adjustable 760mm front &middot; 320mm rear","Tires|2.5-14 front &middot; 3-12 rear","Seat Height|30 in","Fuel Capacity|3.7 liters","Frame|Single-tube high-strength steel") },
  @{ Slug="db-x6-125cc"; Name="DB-X6 125cc"; Image="dbx6-125.jpg";
     Specs=@("Engine|125cc, 4-stroke, air-cooled","Power|10.0kW @ 9500 rpm","Starting|Kick start","Transmission|1-speed fully automatic","Brakes|Front &amp; rear hydraulic disc","Suspension|Hydraulic front forks &middot; non-adjustable 320mm rear","Tires|2.5-14 front &middot; 3-12 rear","Seat Height|740mm &middot; Wheelbase: 1200mm","Weight|79 kg gross &middot; 64 kg net","Fuel Capacity|3.7 liters","Frame|Single-tube high-strength steel") },
  @{ Slug="db-x14-125cc-new-frame"; Name="DB-X14 125cc &ndash; New Frame"; Image="dbx14-125.jpg";
     Specs=@("Engine|125cc, 4-stroke, single-cylinder","Power|6.0kW @ 7500 rpm","Starting|Kick start","Transmission|4-speed semi-automatic","Brakes|Front &amp; rear hydraulic disc","Suspension|Non-adjustable 760mm front &middot; 320mm rear","Tires|2.5-14 front &middot; 3.0-12 rear","Seat Height|33 in","Weight|82 kg gross &middot; 67 kg net","Fuel Capacity|4.7 liters","Frame|Twin-spar heavy-duty steel") },
  @{ Slug="db-x15-125cc-new-frame"; Name="DB-X15 125cc &ndash; New Frame"; Image="dbx15-125.jpg";
     Specs=@("Engine|125cc, 4-stroke, single-cylinder","Power|6.0kW @ 7500 rpm","Starting|Kick start","Transmission|4-speed manual clutch","Brakes|Front &amp; rear hydraulic disc","Suspension|Non-adjustable 760mm front &middot; 320mm rear","Tires|2.5-14 front &middot; 3.0-12 rear","Seat Height|33 in","Weight|82 kg gross &middot; 67 kg net","Fuel Capacity|4.7 liters","Frame|Twin-spar heavy-duty steel") },
  @{ Slug="db-x16-125cc-new-frame"; Name="DB-X16 125cc &ndash; New Frame"; Image="dbx16-125.jpg";
     Specs=@("Engine|125cc, 4-stroke, single-cylinder","Power|6.0kW @ 7500 rpm","Starting|Kick start","Transmission|1-speed fully automatic","Brakes|Front &amp; rear hydraulic disc","Suspension|Non-adjustable 760mm front &middot; 320mm rear","Tires|2.5-14 front &middot; 3.0-12 rear","Seat Height|33 in","Weight|82 kg gross &middot; 67 kg net","Fuel Capacity|4.7 liters","Frame|Twin-spar heavy-duty steel") },
  @{ Slug="db-x18-125cc-new-frame"; Name="DB-X18 125cc &ndash; New Frame"; Image="dbx18-125.jpg";
     Specs=@("Engine|125cc, 4-stroke, single-cylinder","Power|6.0kW @ 7500 rpm","Starting|Kick start","Transmission|4-speed manual clutch","Brakes|Front &amp; rear hydraulic disc","Suspension|Non-adjustable 750mm front &middot; 320mm rear","Tires|17in front &middot; 14in rear","Seat Height|34 in","Weight|82 kg gross &middot; 67 kg net","Fuel Capacity|4.7 liters","Frame|Twin-spar heavy-duty steel") },
  @{ Slug="db-x19-125cc-new-frame"; Name="DB-X19 125cc &ndash; New Frame"; Image="dbx19-125.jpg";
     Specs=@("Engine|125cc, 4-stroke, single-cylinder","Power|6.0kW @ 7500 rpm","Starting|Electric &amp; kick start","Transmission|4-speed manual clutch","Brakes|Front &amp; rear hydraulic disc","Suspension|Non-adjustable 750mm front &middot; 320mm rear","Tires|17in front &middot; 14in rear","Seat Height|34 in &middot; Wheelbase: 1220mm","Weight|82 kg gross &middot; 67 kg net","Fuel Capacity|4.7 liters","Frame|Twin-spar heavy-duty steel","Extras|Headlight included") },
  @{ Slug="thunder-t20"; Name="Thunder T20"; Image="thundert20.jpg";
     Specs=@("Engine|125cc, 4-stroke, single-cylinder","Power|6.0kW @ 7500 rpm","Starting|Kick start","Transmission|4-speed manual clutch","Brakes|Front &amp; rear hydraulic disc","Suspension|Non-adjustable 750mm front &middot; 320mm rear","Wheels|17in front &middot; 14in rear","Seat Height|34 in &middot; Wheelbase: 1220mm","Weight|82 kg gross &middot; 67 kg net","Fuel Capacity|4.7 liters","Frame|Twin-spar heavy-duty steel") },
  @{ Slug="vitacci-raven-250cc-xl"; Name="Vitacci Raven 250cc XL"; Image="vitacciraven250xl.jpg";
     Specs=@("Engine|229cc, 4-stroke, air-cooled, CDI ignition","Power|11.5 HP @ 7500 rpm &middot; 17.0 N&middot;m torque @ 5500 rpm","Top Speed|68 mph","Starting|Electric &amp; kick start","Transmission|Chain drive","Brakes|Hydraulic disc, front &amp; rear","Tires|3.00-21 front &middot; 4.60-18 rear","Suspension|Double shocks front &middot; single shock rear","Seat Height|35 in &middot; Wheelbase: 53.9 in","Dimensions|82.2 &times; 36.2 &times; 56.6 in","Weight|311 lbs gross &middot; 276 lbs net","Fuel Capacity|14 liters") },
  @{ Slug="thunder-140"; Name="Thunder 140"; Image="thunder140.jpg";
     Specs=@("Engine|140cc, 4-stroke, single-cylinder (YX brand)","Power|11 HP @ 8000 rpm &middot; 10.2 N&middot;m torque @ 7500 rpm","Compression Ratio|9.8:1","Starting|Kick start","Transmission|4-speed manual (N-1-2-3-4), chain drive","Brakes|Hydraulic disc, front &amp; rear","Tires|70/100-17 front &middot; 90/100-14 rear","Suspension|30.3in front &middot; 13.8in rear, non-adjustable (SYD)","Seat Height|33 in &middot; Wheelbase: 48 in","Ground Clearance|13 in","Weight|176 lbs net &middot; 198 lbs gross","Fuel Capacity|1.03 gallons","Frame|Heavy-duty double-beam steel") },
  @{ Slug="thunder-150cc"; Name="Thunder 150cc"; Image="thunder150.jpg";
     Specs=@("Engine|140cc, air-cooled, 4-stroke, single-cylinder (YX brand)","Power|11 HP @ 8000 rpm &middot; 10.2 N&middot;m torque @ 7500 rpm","Compression Ratio|9.8:1","Starting|Kick start","Transmission|4-speed manual (N-1-2-3-4), chain drive","Brakes|Hydraulic disc, front &amp; rear","Tires|70/100-19 front &middot; 90/100-16 rear","Suspension|31.9in front (non-adj.) &middot; 13.8in rear (adj.), SYD","Seat Height|34.5 in &middot; Wheelbase: 49.2 in","Ground Clearance|14.5 in","Weight|192 lbs net &middot; 221 lbs gross","Fuel Capacity|1.03 gallons","Frame|Double-beam heavy-duty steel") },
  @{ Slug="thunder-150cc-dlx"; Name="Thunder 150cc DLX"; Image="thunder150dlx.jpg";
     Specs=@("Engine|140cc, air-cooled, 4-stroke, single-cylinder","Power|11 HP @ 8000 rpm &middot; 10.2 N&middot;m torque @ 7500 rpm","Starting|Kick start","Transmission|4-speed manual (N-1-2-3-4), chain drive","Brakes|Hydraulic disc, front &amp; rear","Tires|70/100-19 front &middot; 90/100-16 rear","Suspension|31.9in front (non-adj.) &middot; 13.8in rear (adj.)","Seat Height|34.5 in &middot; Wheelbase: 49.2 in","Ground Clearance|14.5 in","Weight|192 lbs net &middot; 221 lbs gross","Extras|Front light and hour meter") },
  @{ Slug="db-36-250cc"; Name="DB-36 250cc"; Image="db36-250.jpg";
     Specs=@("Engine|250cc, air-cooled, 4-stroke","Power|13kW @ 7000 rpm","Starting|Electric &amp; kick start","Transmission|Manual, 5-speed","Brakes|Front &amp; rear hydraulic disc","Tires|80/100-21 front &middot; 110/90-18 rear","Suspension|54mm inverted front fork, 265mm travel &middot; adjustable rear","Seat Height|930mm &middot; Wheelbase: 1420mm","Weight|128 kg gross &middot; 108 kg net","Fuel Capacity|7 liters","Frame|Twin-spar heavy-duty steel") },
  @{ Slug="thunder-250cc"; Name="Thunder 250cc"; Image="thunder250.jpg";
     Specs=@("Engine|250cc, air-cooled, 4-stroke, single-cylinder (Zongshen)","Power|16.1 HP @ 7000 rpm &middot; 17.5 N&middot;m torque @ 5500 rpm","Starting|Electric &amp; kick start","Transmission|Manual clutch, 5-speed, chain drive","Fuel Capacity|1.7 gallons","Brakes|Hydraulic disc, front &amp; rear","Tires|80/100-21 front &middot; 100/90-18 rear","Suspension|54mm inverted front fork, 200mm travel (adj.) &middot; 450mm rear (adj.)","Seat Height|35.8 in &middot; Wheelbase: 52.8 in","Ground Clearance|13.5 in","Weight|233 lbs net","Frame|Double-beam heavy-duty steel") },
  @{ Slug="thunder-250cc-dlx"; Name="Thunder 250cc DLX"; Image="thunder250dlx.jpg";
     Specs=@("Engine|250cc, air-cooled, 4-stroke, single-cylinder (Zongshen)","Power|16.1 HP @ 7000 rpm &middot; 17.5 N&middot;m torque @ 5500 rpm","Compression Ratio|9.9:1","Starting|Electric &amp; kick start","Transmission|Manual clutch, 5-speed, chain drive","Fuel Capacity|1.7 gallons","Brakes|Hydraulic disc, front &amp; rear","Tires|80/100-21 front &middot; 100/90-18 rear","Suspension|54mm inverted front fork, 200mm travel (adj.)","Seat Height|35.8 in &middot; Wheelbase: 52.8 in","Ground Clearance|13.5 in","Weight|233 lbs net","Frame|Double-beam heavy-duty steel") },
  @{ Slug="thunder-300cc"; Name="Thunder 300cc"; Image="thunder300.jpg";
     Specs=@("Engine|271.3cc, single-cylinder, air-cooled, oblique OHC","Power|16kW @ 8500 rpm","Top Speed|100+ km/h","Starting|Electric &amp; kick start","Drive|520H-110 chain","Brakes|Hydraulic disc, 270mm front &middot; 240mm rear","Tires|80/100-21 front &middot; 100/90-18 rear","Suspension|880mm double-adjustable front fork, 265mm travel &middot; 450mm single-adjustable rear shock, 72mm travel","Seat Height|945mm","Wheelbase|1367mm &middot; Ground Clearance: 340mm","Weight|111 kg dry &middot; 129 kg gross","Max Load|90 kg","Extras|Waterproof wiring harness, stainless steel muffler, integrated headlight") },
  @{ Slug="rxf150-freeride"; Name="RXF150 Freeride"; Image="rxf150.jpg";
     Specs=@("Engine|140cc, 4-stroke, single-cylinder, air-cooled","Power|11 HP @ 8000 rpm &middot; 10.2 N&middot;m torque @ 7500 rpm","Starting|Kick start","Transmission|4-speed manual (N-1-2-3-4), chain drive","Brakes|Hydraulic disc, front &amp; rear (foot)","Tires|70/100-17 front &middot; 90/100-14 rear","Suspension|32.7in front, non-adjustable &middot; 13.8in rear, adjustable","Seat Height|35 in &middot; Wheelbase: 51.2 in","Ground Clearance|13.8 in","Weight|187 lbs net &middot; 209 lbs gross","Fuel Capacity|1.4 gallons","Frame|Double-beam heavy-duty steel") }
)

$headerTemplate = @'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{NAME_PLAIN} | Dirt Bikes | NYC ATV Warehouse</title>
<meta name="description" content="{NAME_PLAIN} dirt bike for sale at NYC ATV Warehouse in Little Ferry, NJ. Full specs, pricing, and availability.">
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
      <p class="eyebrow"><a href="../dirtbikes.html" style="color:inherit;">Dirt Bikes</a> / {NAME}</p>
      <h1 class="section-title">{NAME}</h1>
    </div>
  </div>
</section>

<!-- ===== Product Detail ===== -->
<section class="section-alt">
  <div class="container split">
    <div class="split-media">
      <img id="mainPhoto" src="../images/{IMAGE}" alt="{NAME_PLAIN} dirt bike">
    </div>
    <div class="gallery-thumbs" style="grid-column:1;">
{GALLERY_THUMBS}
    </div>
    <div class="split-text">
      <p class="eyebrow">Dirt Bike</p>
      <h2 class="section-title">{NAME}</h2>
      <p class="spec-price">Call for Pricing</p>
      <ul class="spec-list">
{SPEC_ITEMS}
      </ul>
      <a href="../index.html#contact" class="btn btn-primary">Ask About This Bike</a>
      <p style="margin-top:16px;"><a href="../dirtbikes.html" style="color:inherit;">&larr; Back to all Dirt Bikes</a></p>
    </div>
  </div>
</section>

<!-- ===== CTA Banner ===== -->
<div class="cta-banner">
  <div class="container">
    <h2>Don't see what you're looking for?</h2>
    <p>We carry dozens of dirt bike models — call the warehouse and we'll check current stock and pricing.</p>
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
          <li>120 Industrial Ave<br>Little Ferry, NJ 07643</li>
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

foreach ($b in $bikes) {
  $specItems = ($b.Specs | ForEach-Object {
    $parts = $_ -split '\|', 2
    "        <li><strong>$($parts[0]):</strong> $($parts[1])</li>"
  }) -join "`n"

  $nameHtml = $b.Name
  $namePlain = $b.Name -replace '&ndash;','-' -replace '&amp;','and'

  $stem = [System.IO.Path]::GetFileNameWithoutExtension($b.Image)
  $imagesDir = Join-Path $root "images"
  $galleryFiles = @($b.Image)
  for ($i = 2; $i -le 6; $i++) {
    $candidate = "$stem-$i.jpg"
    if (Test-Path (Join-Path $imagesDir $candidate)) {
      $galleryFiles += $candidate
    }
  }

  $thumbLines = for ($i = 0; $i -lt $galleryFiles.Count; $i++) {
    $activeClass = if ($i -eq 0) { " active" } else { "" }
    $photoNum = $i + 1
    "      <img src=`"../images/$($galleryFiles[$i])`" class=`"thumb$activeClass`" alt=`"$namePlain photo $photoNum`" onclick=`"document.getElementById('mainPhoto').src=this.src;document.querySelectorAll('.gallery-thumbs .thumb').forEach(function(t){t.classList.remove('active')});this.classList.add('active');`">"
  }
  $galleryThumbs = $thumbLines -join "`n"

  $page = $headerTemplate
  $page = $page.Replace("{NAME_PLAIN}", $namePlain)
  $page = $page.Replace("{NAME}", $nameHtml)
  $page = $page.Replace("{IMAGE}", $b.Image)
  $page = $page.Replace("{SPEC_ITEMS}", $specItems)
  $page = $page.Replace("{GALLERY_THUMBS}", $galleryThumbs)

  $outPath = Join-Path $outDir ($b.Slug + ".html")
  [System.IO.File]::WriteAllText($outPath, $page, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "Wrote $outPath"
}

Write-Host "Done: $($bikes.Count) pages generated."
