$root = "C:\Users\HI\Desktop\NYCATVS"
$outDir = Join-Path $root "ebikes"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$bikes = @(
  @{ Slug="ouxi-gt-2000"; Name="OUXI GT-2000"; Image="gt2000.jfif"; Price=1299; Buy="deposit"; Stripe="https://buy.stripe.com/9B69AScpP7LN6o6cbK97G0u";
     Specs=@("Motor|2000W rated / 3000W peak brushless rear hub motor","Battery|Removable 48V 30Ah (~1440Wh) lithium","Top Speed|37 mph claimed (~32 mph tested)","Range|35&ndash;75 mi electric, up to 87 mi pedal-assist","Charging Time|6&ndash;7 hours","Tires|24&quot; x 3.0&quot; off-road fat tires","Brakes|Dual-piston hydraulic disc","Drivetrain|Shimano 7-speed","Frame &amp; Suspension|High-carbon steel, front &amp; rear shocks","Max Load|350 lbs &middot; Weight: ~103.5 lbs","Extras|NFC key card start, turn signals, LED lighting, colorful LCD display") },
  @{ Slug="spark-48v"; Name="SPARK 48V"; Image="SPARK48V.jfif"; Price=599; Buy="full"; Stripe="https://buy.stripe.com/fZu00i75veab7safnW97G0q";
     Specs=@("Motor|750W rated / 1800W peak hub","Top Speed|35+ mph","Range|Up to 75 miles") },
  @{ Slug="ouxi-v8"; Name="OUXI V8"; Image="OUXIV8.jfif"; Price=749; Buy="full"; Stripe="https://buy.stripe.com/6oU8wO3Tj9TVfYG1x697G0r";
     Specs=@("Motor|750W hub (up to 1500W peak)","Battery|48V 15Ah","Top Speed|Up to 32 mph (50 km/h)","Range|Up to 45&ndash;60 miles (pedal-assist)","Brakes|Dual disc brake","Weight|~85 lbs (38.5 kg)","Max Load|150 kg (330 lbs)","Extras|LCD display, front suspension, integrated lighting, rear seat") },
  @{ Slug="gt06-e-scooter"; Name="GT06 E-Scooter"; Image="GT06.jfif"; Price=599; Buy="full"; Stripe="https://buy.stripe.com/dRmbJ089z8PR9Ai1x697G0s";
     Specs=@("Motor|1200W brushless rear","Top Speed|25&ndash;32 mph","Frame|Foldable aluminum alloy") },
  @{ Slug="rfn-evo-18"; Name="RFN EVO 18"; Image="evo18.jfif"; Price=1099; Buy="deposit"; Stripe="https://buy.stripe.com/6oU00iblLgijfYGa3C97G0t";
     Specs=@("Motor|500W rated / 750W peak","Battery|Lithium 36V 5Ah &middot; Range: ~15 km","Top Speed|18.6 mph (Sport mode)","Brakes|160mm","Drivetrain|Electronic variator clutch, aluminum alloy swingarm","Tires|18in alloy rims, 18x2.5 front &amp; rear","Suspension|614mm front &middot; 150mm rear","Weight|19 kg &middot; Wheelbase: 940mm","Max Load|70 kg","Built For|Kids &amp; youth ages 8&ndash;12 &middot; Colors: Blue / Red") }
)

$headerTemplate = @'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{NAME_PLAIN} | E-Bikes | NYC ATV Warehouse</title>
<meta name="description" content="{NAME_PLAIN} electric bike for sale at NYC ATV Warehouse in Little Ferry, NJ. Full specs, pricing, and availability.">
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
      <p class="eyebrow"><a href="../ebikes.html" style="color:inherit;">E-Bikes</a> / {NAME}</p>
      <h1 class="section-title">{NAME}</h1>
    </div>
  </div>
</section>

<!-- ===== Product Detail ===== -->
<section class="section-alt">
  <div class="container split">
    <div class="split-media">
      <img id="mainPhoto" src="../images/{IMAGE}" alt="{NAME_PLAIN} electric bike">
    </div>
{GALLERY_BLOCK}
    <div class="split-text">
      <p class="eyebrow">E-Bike</p>
      <h2 class="section-title">{NAME}</h2>
      <p class="spec-price">{PRICE_DISPLAY}</p>
{BUY_BLOCK}
      <ul class="spec-list">
{SPEC_ITEMS}
      </ul>
      <a href="../index.html#contact" class="btn btn-primary">Ask About This Bike</a>
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

foreach ($b in $bikes) {
  $specItems = ($b.Specs | ForEach-Object {
    $parts = $_ -split '\|', 2
    "        <li><strong>$($parts[0]):</strong> $($parts[1])</li>"
  }) -join "`n"

  if ($b.Buy -eq "full") {
    $priceDisplay = "`$" + "{0:N0}" -f $b.Price
    $buyBlock = "      <a href=`"$($b.Stripe)`" target=`"_blank`" rel=`"noopener`" class=`"btn btn-buy btn-block`">Buy Now &mdash; `$$($b.Price)</a>"
  } else {
    $priceDisplay = "`$" + "{0:N0}" -f $b.Price
    $buyBlock = ""  # reserve/deposit buttons removed
  }

  $nameHtml = $b.Name
  $namePlain = $b.Name

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
      "      <img src=`"../images/$($galleryFiles[$i])`" class=`"thumb$activeClass`" alt=`"$namePlain photo $photoNum`" onclick=`"document.getElementById('mainPhoto').src=this.src;document.querySelectorAll('.gallery-thumbs .thumb').forEach(function(t){t.classList.remove('active')});this.classList.add('active');`">"
    }
    $galleryBlock = "    <div class=`"gallery-thumbs`" style=`"grid-column:1;`">`n" + ($thumbLines -join "`n") + "`n    </div>"
  } else {
    $galleryBlock = ""
  }

  $page = $headerTemplate
  $page = $page.Replace("{NAME_PLAIN}", $namePlain)
  $page = $page.Replace("{NAME}", $nameHtml)
  $page = $page.Replace("{IMAGE}", $b.Image)
  $page = $page.Replace("{PRICE_DISPLAY}", $priceDisplay)
  $page = $page.Replace("{BUY_BLOCK}", $buyBlock)
  $page = $page.Replace("{SPEC_ITEMS}", $specItems)
  $page = $page.Replace("{GALLERY_BLOCK}", $galleryBlock)

  $outPath = Join-Path $outDir ($b.Slug + ".html")
  [System.IO.File]::WriteAllText($outPath, $page, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "Wrote $outPath"
}

Write-Host "Done: $($bikes.Count) pages generated."
