$root = "C:\Users\HI\Desktop\NYCATVS"
$outDir = Join-Path $root "scooters"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$scooters = @(
  @{ Slug="viper-vtr-150cc"; Name="VIPER VTR 150cc"; Image="viper150.jpg"; Price=799; Buy="full"; Stripe="https://buy.stripe.com/5kQ00iexX0jl27Q7Vu97G0v";
     Specs=@("Engine|150cc, 1-cylinder / 4-stroke / 2-valve","Power|6.6kW @ 7500 rpm &middot; 9.2 N&middot;m torque","Top Speed|56 mph","Transmission|Automatic CVT, V-belt final drive","Fuel Capacity|5.6 liters","Battery|12V 6Ah","Brakes|Front disc (180mm) &middot; rear drum (110mm)","Tires|3.50-10 front &amp; rear","Suspension|Telescopic front fork &middot; mono-shock rear","Weight / Seat Height|105 kg dry &middot; 750mm seat","Extras|USB port, alarm system, rear storage box") },
  @{ Slug="tank-pro-x200-elite"; Name="Tank Pro X200 Elite"; Image="tankpro200.jpg"; Price=1299; Buy="deposit"; Stripe="https://buy.stripe.com/eVq28q1LbeabeUCgs097G0w";
     Specs=@("Engine|168.9cc, 1-cylinder / 4-stroke / 2-valve (1P61QMK-A)","Power|7.4kW @ 7000 rpm &middot; 11 N&middot;m torque @ 6000 rpm","Top Speed|59 mph","Transmission|Automatic CVT, V-belt final drive","Fuel Capacity|5.6 liters","Battery|12V 8.6Ah","Brakes|Front disc 230mm (2-piston) &middot; rear disc 220mm (2-piston)","Tires|130/70-13 front &amp; rear","Suspension|Telescopic front fork (95mm travel) &middot; dual shock rear, preload adjustable (60mm travel)","Weight / Seat Height|122 kg dry &middot; 780mm seat","Dimensions|1935mm L &times; 725mm W &times; 1240mm H &middot; 1345mm wheelbase","Max Load|160 kg","Extras|Keyless start, USB charger, alarm, backrest") },
  @{ Slug="tank-defender-150"; Name="Tank Defender 150"; Image="tankdefender150.jpg"; Price=1099; Buy="deposit"; Stripe="https://buy.stripe.com/fZucN4blL5DF7saa3C97G0x";
     Specs=@("Engine|150cc, single-cylinder, 4-stroke, air-cooled","Power|6.8kW @ 7500 rpm &middot; 9.8 N&middot;m torque @ 6000 rpm","Top Speed|~53&ndash;56 mph (85&ndash;90 km/h)","Starting|Electric + kick start","Fuel Capacity|8.0 liters","Brakes|Front disc &middot; rear drum","Tires|120/70-12 front &amp; rear","Weight|118 kg net","Dimensions|1880mm L &times; 740mm W &times; 1140mm H &middot; 1320mm wheelbase","Ground Clearance|130mm","Payload Capacity|150 kg","Battery|12V 7Ah") },
  @{ Slug="marchal-x200-delivery-edition"; Name="Marchal X200 Delivery Edition"; Image="marchalx200.jpg"; Price=1299; Buy="deposit"; Stripe="https://buy.stripe.com/4gM28qdtT1np27QdfO97G0y";
     Specs=@("Engine|168cc GY6, 4-stroke, air-cooled","Power|6.8kW &middot; 9.6 N&middot;m torque","Top Speed|~62 mph (100 km/h)","Transmission|Automatic CVT","Fuel Capacity|5 liters","Brakes|Front disc &middot; rear drum","Tires|130/60-13 front &amp; rear","Suspension|Telescopic front &middot; spring hydraulic rear","Weight|115 kg wet","Max Load|150 kg","Dimensions|1970mm L &times; 710mm W &times; 1160mm H &middot; 1440mm wheelbase","Built For|Delivery","Extras|LED lights, digital speedometer, rear box, MP3, alarm, USB") },
  @{ Slug="intrepid-200"; Name="Intrepid 200"; Image="intrepid200.jpg"; Price=1399; Buy="deposit"; Stripe="https://buy.stripe.com/8x200i2Pffef8we7Vu97G0z";
     Specs=@("Engine|161cc, 1-cylinder / 4-stroke / 2-valve","Power|7.3kW @ 7500 rpm &middot; 11 N&middot;m torque @ 6000 rpm","Top Speed|~63 mph (102 km/h)","Transmission|Automatic CVT, V-belt final drive","Fuel Capacity|13 liters","Battery|12V 8.6Ah","Brakes|Front disc 230mm &middot; rear disc 220mm","Tires|110/70-13 front &middot; 130/60-13 rear","Suspension|Telescopic front fork (90mm travel) &middot; mono-shock rear (88mm travel)","Weight / Seat Height|280 lbs dry &middot; 30 in seat","Dimensions|74 in length &middot; 4.13 in ground clearance","Extras|Rear box, smart key, Bluetooth MP3") },
  @{ Slug="tank-combat-200"; Name="Tank Combat 200"; Image="tankcombat200.jpg"; Price=1599; Buy="none"; Stripe="";
     Specs=@("Engine|169cc, single-cylinder, 4-stroke, forced air-cooled","Power|7.0kW @ 6500 rpm","Top Speed|~53 mph (85 km/h)","Fuel Capacity|8.5 liters","Range|~200+ km","Brakes|Front &amp; rear disc","Tires|130/60-13 front &amp; rear","Suspension|Upright front fork w/ dust cover &middot; reinforced dual rear shocks","Weight / Seat Height|127 kg curb &middot; 785mm seat","Overall Length|1920mm","Extras|Dual leather seat, built-in speakers, 3/4-helmet storage box, full crash bars, LCD panel, anti-theft alarm, electric/kick start") },
  @{ Slug="eco-50cc"; Name="Eco 50cc"; Image="eco50.jpg"; Price=799; Buy="none"; Stripe="";
     Specs=@("Engine|49cc, single-cylinder, 4-stroke, air-cooled","Power|2.4kW @ 8000 rpm &middot; 3.1 N&middot;m torque @ 6500 rpm","Compression Ratio|10.5:1","Transmission|CVT","Starting|Electric + kick start","Fuel Capacity|4.5 liters","Brakes|Front disc &middot; rear drum","Tires|90/90-12, 12in aluminum rims","Suspension|Telescopic front &middot; spring hydraulic rear","Dimensions|1740 &times; 670 &times; 1110mm &middot; 1260mm wheelbase","Weight|82 kg","Battery|12V 7Ah") },
  @{ Slug="magnum-50cc"; Name="Magnum 50cc"; Image="magnum50.jpg"; Price=799; Buy="none"; Stripe="";
     Specs=@("Engine|49.3cc GY6, 4-stroke, air-cooled","Power|2.4kW &middot; 2.8 N&middot;m torque","Top Speed|~37 mph (60 km/h)","Transmission|CVT automatic","Fuel Capacity|4.2 liters","Brakes|Front disc &middot; rear drum","Tires|3.5-10 front &amp; rear","Suspension|Telescopic front &middot; spring hydraulic rear","Weight|50 kg wet","Max Load|100 kg","Dimensions|1700 &times; 650 &times; 1160mm &middot; 1250mm wheelbase","Compression Ratio|10.5:1","Extras|Rear box, alarm, USB") },
  @{ Slug="milano-150"; Name="Milano 150"; Image="milano150.jpg"; Price=999; Buy="none"; Stripe="";
     Specs=@("Engine|150cc (YB150T-9), 1-cylinder, 4-stroke, air-cooled","Power|5.8kW @ 7500 rpm &middot; 9.3 N&middot;m torque @ 7000 rpm","Top Speed|~53 mph (85 km/h)","Fuel System|Carburetor &middot; CDI ignition","Brakes|Front disc &middot; rear drum","Tires|120/70-12 front &amp; rear, aluminum wheels","Suspension|Double absorber rear","Weight|106 kg net","Max Load|150 kg","Dimensions|2020 &times; 680 &times; 1375mm","Extras|Digital speedometer, LED lighting, USB charger, mechanical lock, windshield, rear storage box, alarm, MP3 speakers") },
  @{ Slug="milano-50"; Name="Milano 50"; Image="milano50.jpg"; Price=799; Buy="none"; Stripe="";
     Specs=@("Engine|50cc (YB50QT-9), 1-cylinder, 4-stroke, air-cooled","Power|2.1kW @ 7000 rpm &middot; 7 N&middot;m torque","Top Speed|~28 mph (45 km/h)","Fuel System|Carburetor &middot; CDI ignition","Brakes|Front disc &middot; rear drum","Tires|90/90-12 front &amp; rear, aluminum wheels","Suspension|Double absorber rear","Dimensions|2000 &times; 676 &times; 1340mm &middot; 1275mm wheelbase","Weight|94 kg","Max Load|150 kg","Extras|Digital speedometer, USB charging, mechanical lock, windshield, rear box, alarm, MP3 &amp; speaker") },
  @{ Slug="denali-49cc"; Name="Denali 49cc"; Image="denali49.jpg"; Price=799; Buy="none"; Stripe="";
     Specs=@("Engine|49cc, 4-stroke, single-cylinder, air-forced cool","Power|2.20kW @ 8000 rpm","Top Speed|Up to 25 mph","Fuel Capacity|4.2 liters","Battery|12V 7Ah","Starting|Electric / Kick","Brakes|Front disc &middot; rear drum","Tires|3.00-10 front &amp; rear","Dimensions|1810 &times; 725 &times; 1050mm &middot; 1302mm wheelbase","Weight|180 lbs dry / 200 lbs gross","Weight Capacity|200 lbs","Extras|LED lighting") },
  @{ Slug="razr-150cc"; Name="Razr 150cc"; Image="razr150.jpg"; Price=999; Buy="none"; Stripe="";
     Specs=@("Engine|150cc","Note|Full spec sheet not published online &mdash; ask in-store for complete details") },
  @{ Slug="razr-200cc"; Name="Razr 200cc"; Image="razr200.jpg"; Price=1099; Buy="none"; Stripe="";
     Specs=@("Engine|200cc","Note|Full spec sheet not published online &mdash; ask in-store for complete details") },
  @{ Slug="tank-sport-x200"; Name="Tank Sport X200"; Image="tanksportx200.jpg"; Price=1399; Buy="none"; Stripe="";
     Specs=@("Engine|200cc","Note|Full spec sheet not published online &mdash; ask in-store for complete details") },
  @{ Slug="jag-200"; Name="Jag 200"; Image="jag200.jpg"; Price=1049; Buy="none"; Stripe="";
     Specs=@("Engine|168.9cc, 1-cylinder / 4-stroke / 2-valve","Power|7.4kW @ 7000 rpm &middot; 11 N&middot;m torque @ 6000 rpm","Top Speed|~58 mph (93 km/h)","Transmission|Automatic CVT, V-belt final drive","Fuel Capacity|4.5 liters (carbureted)","Brakes|Front disc 180mm &middot; rear drum 110mm","Tires|3.50-10 front &amp; rear","Suspension|Telescopic front forks (60mm travel) &middot; mono-shock rear (65mm travel)","Weight / Seat Height|90 kg dry &middot; 800mm seat","Dimensions|1775mm length &middot; 125mm ground clearance","Max Load|150 kg","Extras|USB, alarm, rear box") },
  @{ Slug="vtr-200"; Name="VTR 200"; Image="vtr200.jpg"; Price=1499; Buy="none"; Stripe="";
     Specs=@("Engine|168.9cc, 1-cylinder / 4-stroke / 2-valve","Power|7.4kW @ 7000 rpm &middot; 11 N&middot;m torque @ 6000 rpm","Top Speed|59 mph","Transmission|Automatic CVT, V-belt final drive","Fuel Capacity|5.6 liters (carbureted)","Brakes|Front disc 230mm (2-piston) &middot; rear disc 220mm (2-piston)","Tires|120/70-12 front &middot; 130/70-12 rear","Suspension|Telescopic front fork, unadjustable (84mm travel) &middot; dual shock rear, preload adjustable (70mm travel)","Weight / Seat Height|107 kg dry &middot; 800mm seat","Dimensions|1940mm length","Max Payload|160 kg","Extras|USB port, alarm, rear storage box") },
  @{ Slug="viper-150cc"; Name="Viper 150cc"; Image="viper150b.jpg"; Price=999; Buy="none"; Stripe="";
     Specs=@("Engine|149cc, single-cylinder, 4-stroke, air-cooled","Power|6.3kW @ 7500 rpm &middot; 8.8 N&middot;m torque @ 6000 rpm","Compression Ratio|9.2:1","Transmission|CVT (carbureted)","Fuel Capacity|4.2 liters","Brakes|Front disc &middot; rear drum","Tires|3.50-10, 10in aluminum rims","Suspension|Telescopic front &middot; spring hydraulic rear","Dimensions|1780 &times; 640 &times; 1080mm &middot; 1220mm wheelbase","Battery|LIYANG GEL 7A","Extras|USB charger, rear box") },
  @{ Slug="viper-49cc"; Name="Viper 49cc"; Image="viper49.jpg"; Price=799; Buy="none"; Stripe="";
     Specs=@("Engine|49cc, 4-stroke, single-cylinder, air-cooled","Power|2.20kW @ 8000 rpm","Top Speed|25 mph","Fuel Capacity|4.2 liters","Battery|12V 7Ah","Starting|Electric / Kick","Brakes|Front disc &middot; rear drum","Tires|3.00-10 front &amp; rear","Dimensions|1810 &times; 725 &times; 1050mm &middot; 1302mm wheelbase","Weight|180 lbs dry / 200 lbs gross") },
  @{ Slug="viper-st-50cc"; Name="Viper ST-50cc"; Image="viperst50.jpg"; Price=849; Buy="none"; Stripe="";
     Specs=@("Engine|49.6cc (1P39QMA), 1-cylinder / 4-stroke / 2-valve","Power|2.6kW @ 8500 rpm &middot; 3.1 N&middot;m torque @ 7000 rpm","Top Speed|~40 mph (65 km/h)","Transmission|Automatic CVT, V-belt final drive","Fuel Capacity|6.6 liters (carbureted, CDI)","Brakes|Front disc 180mm &middot; rear drum 110mm","Tires|3.50-10 front &amp; rear","Suspension|Telescopic front forks (82mm travel) &middot; mono-shock rear (70mm travel)","Weight / Seat Height|105 kg dry &middot; 750mm seat","Dimensions|1790 &times; 680 &times; 1070mm &middot; 1220mm wheelbase","Extras|USB, alarm, rear box") },
  @{ Slug="focus-st-50cc"; Name="Focus ST-50cc"; Image="focusst50.jpg"; Price=799; Buy="none"; Stripe="";
     Specs=@("Engine|49.6cc (1P39QMA), 1-cylinder / 4-stroke / 2-valve","Power|2.6kW @ 8500 rpm &middot; 3.1 N&middot;m torque @ 7000 rpm","Top Speed|~40 mph (65 km/h)","Transmission|Automatic CVT, V-belt final drive","Fuel Capacity|5.6 liters","Brakes|Front disc 180mm &middot; rear drum 110mm","Tires|3.50-10 front &amp; rear","Suspension|Telescopic front forks (60mm travel) &middot; mono-shock rear (55mm travel)","Weight / Seat Height|105 kg dry &middot; 770mm seat","Max Load|150 kg","Battery|12V 6Ah","Extras|USB, alarm, rear box") },
  @{ Slug="focus-st-150cc"; Name="Focus ST-150cc"; Image="focusst150.jpg"; Price=1049; Buy="none"; Stripe="";
     Specs=@("Engine|150cc (1P57QMJ), 1-cylinder / 4-stroke / 2-valve","Power|6.6kW @ 7500 rpm &middot; 9.2 N&middot;m torque @ 6000 rpm","Top Speed|~58 mph (93 km/h)","Transmission|Automatic CVT, V-belt final drive","Fuel Capacity|5.6 liters","Brakes|Front disc 180mm &middot; rear drum 110mm","Tires|3.50-10 front &amp; rear","Suspension|Telescopic front forks (60mm travel) &middot; mono-shock rear (55mm travel)","Weight / Seat Height|105 kg dry &middot; 770mm seat","Dimensions|1790mm length &times; 680mm width &middot; 125mm ground clearance","Max Load|150 kg","Battery|12V 6Ah","Extras|USB, alarm, rear box") },
  @{ Slug="tank-x200-pro"; Name="Tank X200 Pro"; Image="tankx200pro.jpg"; Price=1499; Buy="none"; Stripe="";
     Specs=@("Engine|168cc GY6, 4-stroke, air-cooled","Power|6.8kW &middot; 9.3 N&middot;m torque","Top Speed|~62 mph (100 km/h)","Transmission|CVT automatic","Fuel Capacity|5 liters","Fuel Consumption|~2.4 L/100km","Brakes|Front &amp; rear disc","Tires|130/60-13 front &amp; rear","Suspension|Telescopic front &middot; spring hydraulic rear","Weight|110 kg wet","Seat Height|80cm","Ground Clearance|11cm","Max Load|150 kg","Extras|USB, Bluetooth, rear basket") },
  @{ Slug="vogue-50"; Name="Vogue 50"; Image="vogue50.jpg"; Price=799; Buy="none"; Stripe="";
     Specs=@("Engine|49cc, single-cylinder, 4-stroke, air-cooled","Power|2.4kW @ 8000 rpm &middot; 2.8 N&middot;m torque @ 6500 rpm","Transmission|CVT","Fuel Capacity|4 liters","Brakes|Front disc &middot; rear drum","Tires|90/90-10, 10in aluminum rims","Suspension|Telescopic front &middot; spring hydraulic rear","Dimensions|1790 &times; 670 &times; 1075mm &middot; 1250mm wheelbase","Battery|LIYANG GEL 7A","Extras|USB charger, rear box") },
  @{ Slug="champion-200-efi"; Name="Champion 200 EFI"; Image="champion200efi.jpg"; Price=1999; Buy="none"; Stripe="";
     Specs=@("Engine|168cc EFI (161QMK)","Power|6.8kW @ 8000 rpm &middot; 9.6 N&middot;m torque @ 5500 rpm","Compression Ratio|11.5:1","Top Speed|~59 mph (95 km/h)","Fuel Capacity|6.8 liters","Fuel Type|Gasoline (EFI)","Brakes|Front &amp; rear brake","Tires|100/80-14 front &middot; 120/70-14 rear","Dimensions|2100 &times; 710 &times; 1110mm &middot; 1370mm wheelbase","Weight|118 kg gross","Battery|12V 7Ah","Extras|Digital speedometer, fuel-injected") }
)

$headerTemplate = @'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{NAME} | Scooters | NYC ATV Warehouse</title>
<meta name="description" content="{NAME} scooter for sale at NYC ATV Warehouse in Little Ferry, NJ. Full specs, pricing, and availability.">
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
      <p class="spec-price">{PRICE_DISPLAY}</p>
{BUY_BLOCK}
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

  $priceDisplay = "`$" + "{0:N0}" -f $s.Price
  if ($s.Buy -eq "full") {
    $buyBlock = "      <a href=`"$($s.Stripe)`" target=`"_blank`" rel=`"noopener`" class=`"btn btn-buy btn-block`">Buy Now &mdash; `$$($s.Price)</a>"
  } elseif ($s.Buy -eq "deposit") {
    $buyBlock = ""  # reserve/deposit buttons removed
  } else {
    $buyBlock = ""
    $priceDisplay = "`$" + "{0:N0}" -f $s.Price
  }

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
  $page = $page.Replace("{NAME}", $s.Name)
  $page = $page.Replace("{IMAGE}", $s.Image)
  $page = $page.Replace("{PRICE_DISPLAY}", $priceDisplay)
  $page = $page.Replace("{BUY_BLOCK}", $buyBlock)
  $page = $page.Replace("{SPEC_ITEMS}", $specItems)
  $page = $page.Replace("{GALLERY_THUMBS}", $galleryThumbs)

  $outPath = Join-Path $outDir ($s.Slug + ".html")
  [System.IO.File]::WriteAllText($outPath, $page, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "Wrote $outPath"
}

Write-Host "Done: $($scooters.Count) pages generated."
