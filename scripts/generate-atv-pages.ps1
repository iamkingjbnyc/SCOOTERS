$root = "C:\Users\HI\Desktop\NYCATVS"
$outDir = Join-Path $root "atvs"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$atvs = @(
  @{ Slug="xwolf-700cc-long-version"; Name="XWOLF 700cc &ndash; Long Version"; Image="xwolf700long.jpg"; Price=0; Buy="none"; Stripe="";
     Specs=@("Engine|686cc, single-cylinder, SOHC, liquid-cooled","Power|35kW (47 HP) @ 5500 rpm &middot; 66 N&middot;m torque @ 4500 rpm","Top Speed|~62 mph (100 km/h)","Fuel System|EFI","Fuel Capacity|25 liters","Transmission|CVT with P/R/N/H/L","Drive|Front differential &middot; 4x4 capable","Brakes|Disc (210mm) front &amp; rear","Tires|25x8-12 front &middot; 25x10-12 rear","Suspension|Dual A-arms, 190mm travel front &middot; 230mm travel rear, oil/gas shocks","Weight|375 kg net","Dimensions|2040mm &times; 1180mm &times; 1250mm &middot; 1300mm wheelbase","Ground Clearance|280mm","Extras|3,000 lb winch, trailer ball, front/rear racks, LCD color display, 32Ah gel battery, USB/DC") },
  @{ Slug="cyber-roamer-300-efi"; Name="Cyber Roamer 300 EFI"; Image="cyberroamer300.jpg"; Price=5499; Buy="deposit"; Stripe="https://buy.stripe.com/4gM9AS2Pf8PRdQygs097G0A";
     Specs=@("Engine|287.2cc, EFI, CVT (L/H/N/R)","Power|17kW @ 6800 rpm &middot; 28 N&middot;m torque @ 5000 rpm","Top Speed|~50 mph (80 km/h)","Drive|Shaft drive 4x4","Cooling|Water cooled","Fuel Capacity|14 liters (steel tank w/ oil sensor)","Brakes|Hydraulic disc, front &amp; rear","Tires|25x8-12 front &middot; 25x10-12 rear, alloy wheels","Weight|315 kg net &middot; 364 kg gross","Max Load|200 kg","Dimensions|2145mm &times; 1100mm &times; 1265mm","Ground Clearance|270mm &middot; Seat Height: 880mm","Extras|Electric power steering (EPS), LED lighting, USB/Type-C, front &amp; rear racks, backrest, armrest") },
  @{ Slug="pentora-hunter-200-efi"; Name="Pentora Hunter 200 EFI"; Image="pentorahunter200.jpg"; Price=2499; Buy="deposit"; Stripe="https://buy.stripe.com/14AfZgahH4zBfYG1x697G0B";
     Specs=@("Engine|177.3cc, 4-stroke, oil + forced air-cooled, balance shaft","Power|7kW rated / 7.3kW max @ 7500 rpm &middot; 10 N&middot;m torque @ 6000 rpm","Top Speed|~37 mph (60 km/h)","Transmission|Chain drive, automatic centrifugal dry clutch","Fuel Capacity|9.7 liters (93 octane)","Brakes|Front &amp; rear hydraulic (hand front, foot rear)","Tires|21x7-10 front &middot; 22x10-10 rear, 10in rims","Suspension|Hydraulic dampers, 345mm front / 350mm rear travel","Weight|197 kg net &middot; 225 kg gross","Dimensions|1860mm &times; 1050mm &times; 1340mm &middot; 1210mm wheelbase","Rider Age|16+","Extras|EFI, electric start") },
  @{ Slug="cyber-roamer-250-efi"; Name="Cyber Roamer 250 EFI"; Image="cyberroamer250.jpg"; Price=0; Buy="none"; Stripe="";
     Specs=@("Engine|224.2cc, single-cylinder, SOHC, 4-stroke, EFI","Power|10.8kW @ 7500 rpm &middot; 15.5 N&middot;m torque @ 6100 rpm","Top Speed|~43 mph (70 km/h)","Transmission|CVT, F+N+R","Drive|Chain, rear-wheel drive","Fuel Capacity|14 liters (steel tank w/ oil sensor)","Brakes|Hydraulic disc, front (hand) &amp; rear (foot)","Tires|23x7-10 front &middot; 22x10-10 rear, alloy wheels","Suspension|Double wishbone independent front &middot; flat fork rear","Weight|205 kg curb","Max Load|150 kg (2-seat capacity)","Dimensions|2050mm &times; 1100mm &times; 1225mm &middot; 1200mm wheelbase","Ground Clearance|170mm &middot; Seat Height: 840mm","Extras|LED lighting, USB port, front/rear racks, backrest") },
  @{ Slug="pentora-sport-250cc"; Name="Pentora Sport 250cc"; Image="pentorasport250.jpg"; Price=2599; Buy="deposit"; Stripe="https://buy.stripe.com/8x2bJ075vc239Ai7Vu97G0C";
     Specs=@("Engine|250cc","Dimensions|1625mm &times; 1060mm &times; 1065mm","Wheelbase|1090 &plusmn; 20mm","Seat Height|790 &plusmn; 15mm","Ground Clearance|135 &plusmn; 15mm","Weight|149 kg net &middot; 177 kg gross","Note|Full performance spec sheet not published online &mdash; ask in-store for complete details") },
  @{ Slug="maximus-450l"; Name="Maximus 450L"; Image="maximus450l.jpg"; Price=0; Buy="none"; Stripe="";
     Specs=@("Engine|391cc, single-cylinder, water-cooled, balance shaft, EFI","Power|20kW @ 6500 rpm &middot; 30 N&middot;m torque @ 5000 rpm","Compression Ratio|10:1","Top Speed|50+ mph (80+ km/h)","Transmission|CVT belt-driven","Drive|4x4","Fuel Capacity|17 liters","Brakes|Front &amp; rear disc","Tires|25x8-12 front &middot; 25x10-12 rear","Suspension|Double A-arm independent, front &amp; rear, coil spring + oil damping","Weight|353 kg curb","Max Load|240 kg","Dimensions|2315mm &times; 1144mm &times; 1340mm &middot; 1460mm wheelbase","Ground Clearance|250mm","Towing|250 kg (no brakes) &middot; 585 kg (with brakes)") },
  @{ Slug="xwolf-700cc-short-version"; Name="XWOLF 700cc &ndash; Short Version"; Image="xwolf700short.jpg"; Price=0; Buy="none"; Stripe="";
     Specs=@("Engine|686cc, single-cylinder, SOHC, liquid-cooled, EFI","Power|35kW @ 5500 rpm &middot; 66 N&middot;m torque @ 4500 rpm","Top Speed|~62 mph (100 km/h)","Transmission|CVT with P/R/N/H/L, front differential","Fuel Capacity|25 liters","Brakes|Disc (210mm) front &amp; rear","Tires|25x8-12 front &middot; 25x10-12 rear, alloy wheels","Suspension|Dual A-arms, 190mm front / 230mm rear travel, oil/gas shocks","Weight|375 kg net","Dimensions|2040mm &times; 1180mm &times; 1250mm &middot; 1300mm wheelbase","Ground Clearance|280mm","Extras|3,000 lb winch, trailer ball, front/rear racks, LCD color display, 32Ah gel battery, USB/DC") },
  @{ Slug="xwolf-550-long-version"; Name="XWOLF 550 &ndash; Long Version"; Image="xwolf550long.png"; Price=0; Buy="none"; Stripe="";
     Specs=@("Engine|550cc Loncin","Frame|Long-wheelbase","Note|Full performance spec sheet not published online &mdash; ask in-store for complete details") },
  @{ Slug="terminator-300cc"; Name="Terminator 300cc"; Image="terminator300.jpg"; Price=0; Buy="none"; Stripe="";
     Specs=@("Engine|257cc (marketed as 300cc), carbureted, 4-stroke, single-cylinder, SOHC, water-cooled","Power|22 HP @ 6500 rpm &middot; 14.8 lb-ft torque @ 5500 rpm","Compression Ratio|10.3:1","Drive|2WD or 4WD switchable","Starting|Electric, T.C.I. ignition","Fuel Capacity|3.8 gallons","Brakes|Hydraulic disc, both sides &middot; front/rear hand &amp; foot parking brake","Tires|AT24x8-12 front &middot; AT24x11-10 rear","Suspension|McPherson independent front &middot; socket centering rear","Weight|618 lbs","Dimensions|83 &times; 46 &times; 50 in &middot; 51 in wheelbase","Ground Clearance|7.2 in","Rider Age|16+") },
  @{ Slug="commander-200cc-efi"; Name="Commander 200cc EFI"; Image="commander200efi.jpg"; Price=0; Buy="none"; Stripe="";
     Specs=@("Engine|174.4cc, 4-stroke, single-cylinder, air-cooled, EFI","Power|7.3kW @ 7500 rpm &middot; 10 N&middot;m torque @ 6000 rpm","Top Speed|~37 mph (60 km/h)","Transmission|CVT, F-N-R, chain drive","Fuel Capacity|6 liters (RQ-93)","Brakes|Hydraulic, hand front / foot rear","Tires|23x7-10 front (10psi) &middot; 22x10-10 rear (10psi)","Weight|165 kg curb &middot; 188 kg gross","Dimensions|1670mm &times; 1020mm &times; 1100mm","Seat Height|760mm &middot; Ground Clearance: 135mm","Extras|Electric start, CDI ignition, 12V 9Ah battery","Rider Age|16+") },
  @{ Slug="commander-200cc"; Name="Commander 200cc"; Image="commander200.jpg"; Price=2499; Buy="deposit"; Stripe="https://buy.stripe.com/6oU8wO9dDaXZaEmejS97G0D";
     Specs=@("Engine|174.4cc","Power|7.3kW","Top Speed|~37 mph (60 km/h)","Transmission|Full-automatic with reverse, chain drive","Fuel Capacity|6 liters (steel tank)","Brakes|Double hydraulic disc front (hand) &middot; single hydraulic disc rear (foot)","Tires|23x7-10 front &middot; 22x10-10 rear, steel rims","Weight|353 lbs net &middot; 415 lbs gross","Max Load|330 lbs &middot; Tow Capacity: 300 lbs","Seat Height|31.8 in &middot; Ground Clearance: 7.2 in","Rider Age|16+","Extras|Available in 7 colors") },
  @{ Slug="cougar-ut-200cc"; Name="Cougar UT 200cc"; Image="cougarut200.jpg"; Price=2299; Buy="deposit"; Stripe="https://buy.stripe.com/00w00i9dD3vx6o61x697G0E";
     Specs=@("Engine|200cc, 4-stroke, single-cylinder, air-cooled","Power|9.1kW @ 7500 rpm &middot; 10 N&middot;m torque @ 6500 rpm","Top Speed|~40 mph (65 km/h)","Transmission|F-N-R, chain drive","Fuel|PD24J carburetor, CDI ignition &middot; 4.2L tank &middot; 3.3 L/100km","Brakes|Ventilated hydraulic disc, front &amp; rear","Tires|23x7-10 front &middot; 22x10-10 rear, radial","Suspension|Independent double swing arm front &middot; single swing arm rear","Weight|164 kg dry","Max Load|150 kg","Dimensions|1700mm &times; 1040mm &times; 1100mm","Seat Height|810mm &middot; Ground Clearance: 135mm") },
  @{ Slug="cougar-sport-200cc"; Name="Cougar Sport 200cc"; Image="cougarsport200.png"; Price=2499; Buy="deposit"; Stripe="https://buy.stripe.com/5kQ6oG61r2rtfYG6Rq97G0F";
     Specs=@("Engine|169cc, air-cooled, 4-stroke, automatic","Ignition|CDI","Torque|7.5 N&middot;m @ 5000&ndash;5500 rpm","Transmission|Fully automatic with reverse, chain drive, hand shift","Fuel Capacity|4.2 liters","Brakes|Front drum (hand) &middot; rear hydraulic disc (foot)","Tires|21x7-10 front &middot; 20x10-10 rear","Suspension|13.4in travel front &middot; 14.2in travel rear","Weight|330 lbs net &middot; 374 lbs gross","Max Load|165 lbs","Dimensions|62 &times; 44.5 &times; 43.3 in &middot; 43.52in wheelbase","Ground Clearance|12 in","Extras|Electric start, 12V/9Ah battery") },
  @{ Slug="pentora-200-efi"; Name="Pentora 200 EFI"; Image="pentora200efi.jpg"; Price=2499; Buy="deposit"; Stripe="https://buy.stripe.com/eVq4gydtT4zBcMu6Rq97G0G";
     Specs=@("Engine|223cc (LC166FMM), single-cylinder, air-cooled, 2-valve, 4-stroke, EFI","Power|12kW @ 7500 rpm &middot; 17 N&middot;m torque @ 6000 rpm","Top Speed|~43 mph (70 km/h)","Transmission|Chain, manual clutch, electric start","Fuel|&ge;RQ90 &middot; 9L tank","Brakes|Front &amp; rear hydraulic disc (hand front, foot rear)","Tires|AT20x7.0-10 front &middot; AT19x10-9 rear","Suspension|Oil damper, 350mm front / 390mm rear","Weight|149 kg net &middot; 177 kg gross","Rated Load|100 kg","Extras|Climb capability 21&deg;, 0-top speed &le;8 sec") },
  @{ Slug="pentora-sport-150cc"; Name="Pentora Sport 150cc"; Image="pentorasport150.jpg"; Price=0; Buy="none"; Stripe="";
     Specs=@("Engine|149.6cc, single-cylinder, air-cooled, 4-stroke","Power|7.3kW @ 7000 rpm max &middot; 8kW @ 8000 rpm rated &middot; 10.1 N&middot;m torque @ 6000 rpm","Top Speed|~43 mph (70 km/h)","Transmission|Chain drive","Fuel Capacity|9 liters","Brakes|Front &amp; rear disc, hand-operated","Tires|AT20x7.0-10 front &middot; AT19x10-9 rear","Suspension|Oil damper, 2.7in front / 3.1in rear travel","Weight|315 lbs net","Seat Height|31.1 in &middot; Max Load: 220 lbs","Rider Age|16+") },
  @{ Slug="pentora-iride-125cc"; Name="Pentora Iride 125cc"; Image="pentorairide125.jpg"; Price=1499; Buy="deposit"; Stripe="https://buy.stripe.com/dRm14m61r1npbIq3Fe97G0H";
     Specs=@("Engine|123.67cc, single-cylinder, 4-stroke, air-cooled, balance shaft","Power|6.3kW @ 7500 rpm &middot; 8.8 N&middot;m torque @ 5500 rpm","Compression Ratio|9.0:1","Transmission|Automatic F-N-R, two-stage, wet multi-plate clutch, chain drive","Fuel Capacity|7 liters","Brakes|Front &amp; rear disc, hand-operated","Tires|18x7-8 front &middot; 18x9-8 rear, 8in rims","Suspension|Oil damper, 270mm front / 285mm rear","Weight|109 kg net &middot; 131 kg gross","Max Load|82 kg","Wheelbase|970mm &middot; Ground Clearance: 180mm") },
  @{ Slug="pentora-125cc"; Name="Pentora 125cc"; Image="pentora125.png"; Price=1599; Buy="deposit"; Stripe="https://buy.stripe.com/8x28wOblL6HJ8web7G97G0I";
     Specs=@("Engine|123.67cc (ZS154FMI), air-cooled, 4-stroke, automatic with reverse","Power|6.3kW @ 7500 rpm &middot; 8.8 N&middot;m torque @ 5500 rpm","Fuel Capacity|6.5 liters","Brakes|Front &amp; rear disc, hand-operated","Tires|18x7-8 front &middot; 18x9-8 rear, 8in rims","Suspension|Oil damper, 2in front / 2.3in rear travel","Weight|260 lbs net &middot; 285 lbs gross","Max Load|150 lbs","Dimensions|61 &times; 39 &times; 42 in &middot; Seat Height: 29 in","Rider Age|16+") },
  @{ Slug="falcon-x-125cc"; Name="Falcon X 125cc"; Image="falconx125.jpg"; Price=1499; Buy="deposit"; Stripe="https://buy.stripe.com/dRmeVc9dD7LNeUC8Zy97G0J";
     Specs=@("Engine|119.7cc (AGA-12A), 4-stroke, single-cylinder, air-cooled","Power|5.5kW @ 7500 rpm &middot; 8.5 N&middot;m torque @ 5000 rpm","Top Speed|~34 mph (55 km/h)","Transmission|Semi-automatic 1+R, chain drive","Ignition|CDI, electric start, RQ-93 fuel","Brakes|Front hydraulic (hand) &middot; rear hydraulic (foot)","Tires|19x7-8 front (10psi) &middot; 18x9.5-8 rear (10psi), steel rims","Weight|123 kg curb","Max Load|100 kg","Dimensions|1495mm &times; 970mm &times; 1000mm","Seat Height|760mm &middot; Ground Clearance: 125mm","Rider Age|12+") },
  @{ Slug="commander-125cc"; Name="Commander 125cc"; Image="commander125.jpg"; Price=1499; Buy="deposit"; Stripe="https://buy.stripe.com/7sYcN49dD1np4fYb7G97G0K";
     Specs=@("Engine|125cc, single-cylinder, air-cooled, 4-stroke","Top Speed|~34 mph (55 km/h)","Transmission|Full-automatic with reverse, chain drive, electric start only","Fuel Capacity|2.3 liters &middot; Battery: 12V 5Ah","Brakes|Front drum &middot; rear disc","Tires|19x7-8 front &middot; 18x9.5-8 rear","Weight|95 kg dry","Dimensions|1410mm &times; 1010mm &times; 965mm","Ground Clearance|110mm &middot; Rated Load: 75kg","Rider Age|12+") },
  @{ Slug="blazer-9-125cc"; Name="Blazer 9 125cc"; Image="blazer9125.jpg"; Price=1499; Buy="deposit"; Stripe="https://buy.stripe.com/aFaaEW9dD3vxdQy1x697G0L";
     Specs=@("Engine|125cc, single-cylinder, air-cooled, 4-stroke","Top Speed|~34 mph (55 km/h)","Transmission|Full-automatic with reverse, chain drive, electric start only","Fuel Capacity|2.3 liters &middot; Battery: 12V 5Ah","Brakes|Front drum &middot; rear disc","Tires|19x7-8 front &middot; 18x9.5-8 rear","Weight|240 lbs dry","Seat Height|730mm &middot; Wheelbase: 950mm &middot; Ground Clearance: 110mm","Rated Load|150 lbs","Rider Age|12+") },
  @{ Slug="racer-125cc"; Name="Racer 125cc"; Image="racer125.jpg"; Price=1499; Buy="deposit"; Stripe="https://buy.stripe.com/6oU00i75veab9Ai7Vu97G0M";
     Specs=@("Engine|125cc, single-cylinder, 4-stroke, air-cooled","Top Speed|34 mph","Starting|Electric, CDI ignition","Transmission|Automatic with reverse, foot shift, chain drive","Fuel Capacity|0.61 gallons &middot; Battery: 12V 5Ah","Brakes|Drum front &middot; hydraulic disc rear","Tires|19x7-8 front &middot; 18x9.5-8 rear","Weight|285 lbs net","Max Load|166 lbs &middot; Ground Clearance: 4.3 in","Rider Age|12+","Extras|Includes rear rack") },
  @{ Slug="rider-10-125cc"; Name="Rider 10 &ndash; 125cc"; Image="rider10125.jpg"; Price=1499; Buy="deposit"; Stripe="https://buy.stripe.com/dRmdR8ahHfef13Mb7G97G0N";
     Specs=@("Engine|125cc, single-cylinder, 4-stroke, air-cooled","Torque|5.7 N&middot;m @ 7500 &plusmn; 500 rpm","Top Speed|43.5 mph","Climbing Ability|18&deg;","Transmission|Automatic with reverse, hand shift, chain drive","Starting|Electric, CDI ignition &middot; Fuel: 0.63 gal &middot; Battery: 12V 5Ah","Brakes|Drum front &middot; hydraulic disc rear","Tires|19x7-8 front &middot; 18x9.5-8 rear","Seat Height|26.8 in &middot; Ground Clearance: 5.5 in","Weight|234 lbs net","Max Load|228 lbs &middot; Wheelbase: 37.8 in","Rider Age|12+","Extras|Remote on/off capability") },
  @{ Slug="rider-9-125cc"; Name="Rider 9 &ndash; 125cc"; Image="rider9125.jpg"; Price=0; Buy="none"; Stripe="";
     Specs=@("Engine|119.6cc (marketed as 125cc), single-cylinder, 4-stroke, air-cooled","Power|5.5kW @ 8500 rpm &middot; 6.9 N&middot;m torque @ 6500 rpm","Carburetor|PZ20 &middot; Ignition: AC-CDI","Transmission|Chain, one forward/one reverse, hand gear shift","Fuel Capacity|2.2 liters","Brakes|Front drum &middot; rear disc","Tires|19x7-8 front &middot; 18x9.5-8 rear","Suspension|Traverse double-arm front &middot; non-independent rear","Weight|236 lbs net &middot; 289 lbs gross","Dimensions|62 &times; 38 &times; 37 in &middot; Seat Height: 27.5 in","Max Load|143 lbs","Rider Age|10+","Extras|Electric start") },
  @{ Slug="mini-commander-110cc"; Name="Mini Commander 110cc"; Image="minicommander110.jpg"; Price=1399; Buy="deposit"; Stripe="https://buy.stripe.com/9B628qfC13vx13McbK97G0O";
     Specs=@("Engine|106.7cc (AGA-10), 4-stroke, single-cylinder, air-cooled","Power|5.0kW @ 7500 rpm &middot; 7.0 N&middot;m torque @ 5500 rpm","Top Speed|~15 mph (24 km/h)","Transmission|Semi-automatic 1+R, chain drive, RQ-93 fuel","Max Gradability|10&deg; &middot; Min Turning Radius: 2500mm","Brakes|Hydraulic front (hand) &middot; hydraulic rear with parking brake (foot)","Tires|145/70-6 front &amp; rear (10psi)","Weight|86 kg curb","Rated Load|70 kg","Dimensions|1200mm &times; 745mm &times; 785mm","Seat Height|~22.8 in (kids) &middot; Ground Clearance: 90mm","Rider Age|6+ (youth recreational)") },
  @{ Slug="rxr-110cc"; Name="RXR 110cc"; Image="rxr110.jpg"; Price=1399; Buy="deposit"; Stripe="https://buy.stripe.com/dRm4gy3Tj9TV5k26Rq97G0P";
     Specs=@("Engine|107cc, 4-stroke, single-cylinder, air-cooled","Power|4.8kW @ 8000 &plusmn; 500 rpm &middot; 6.9 N&middot;m torque @ 6500 &plusmn; 500 rpm","Ignition|CDI, electric start","Fuel Capacity|2.2 liters (plastic tank) &middot; Battery: 12V 5Ah","Transmission|Chain, rear-wheel drive, automatic with reverse","Brakes|Drum front &middot; hydraulic disc rear","Tires|16x8-7 front &amp; rear","Weight|216 kg gross &middot; 158 kg net","Wheelbase|960mm &middot; Dimensions: 1340mm &times; 930mm &times; 900mm","Seat Height|~23.6 in") }
)

$headerTemplate = @'
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=AW-11412137626"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'AW-11412137626');
</script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{NAME_PLAIN} | ATVs | NYC ATV Warehouse</title>
<meta name="description" content="{NAME_PLAIN} ATV for sale at NYC ATV Warehouse in Little Ferry, NJ. Full specs, pricing, and availability.">
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
      <p class="eyebrow"><a href="../atvs.html" style="color:inherit;">ATVs</a> / {NAME}</p>
      <h1 class="section-title">{NAME}</h1>
    </div>
  </div>
</section>

<!-- ===== Product Detail ===== -->
<section class="section-alt">
  <div class="container split">
    <div class="split-media">
      <img id="mainPhoto" src="../images/{IMAGE}" alt="{NAME_PLAIN} ATV">
    </div>
    <div class="gallery-thumbs" style="grid-column:1;">
{GALLERY_THUMBS}
    </div>
    <div class="split-text">
      <p class="eyebrow">ATV</p>
      <h2 class="section-title">{NAME}</h2>
      <p class="spec-price">{PRICE_DISPLAY}</p>
{BUY_BLOCK}
      <ul class="spec-list">
{SPEC_ITEMS}
      </ul>
      <a href="../contact.html" class="btn btn-primary">Ask About This ATV</a>
      <p style="margin-top:16px;"><a href="../atvs.html" style="color:inherit;">&larr; Back to all ATVs</a></p>
    </div>
  </div>
</section>

<!-- ===== CTA Banner ===== -->
<div class="cta-banner">
  <div class="container">
    <h2>Don't see what you're looking for?</h2>
    <p>We carry dozens of ATV models — call the warehouse and we'll check current stock and pricing.</p>
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

foreach ($a in $atvs) {
  $specItems = ($a.Specs | ForEach-Object {
    $parts = $_ -split '\|', 2
    "        <li><strong>$($parts[0]):</strong> $($parts[1])</li>"
  }) -join "`n"

  if ($a.Buy -eq "deposit") {
    $priceDisplay = "`$" + "{0:N0}" -f $a.Price
    $buyBlock = ""  # reserve/deposit buttons removed
  } else {
    $priceDisplay = "Call for Pricing"
    $buyBlock = ""
  }

  $nameHtml = $a.Name
  $namePlain = $a.Name -replace '&ndash;','-' -replace '&deg;','deg' -replace '&amp;','and'

  $stem = [System.IO.Path]::GetFileNameWithoutExtension($a.Image)
  $imagesDir = Join-Path $root "images"
  $galleryFiles = @($a.Image)
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
  $page = $page.Replace("{IMAGE}", $a.Image)
  $page = $page.Replace("{PRICE_DISPLAY}", $priceDisplay)
  $page = $page.Replace("{BUY_BLOCK}", $buyBlock)
  $page = $page.Replace("{SPEC_ITEMS}", $specItems)
  $page = $page.Replace("{GALLERY_THUMBS}", $galleryThumbs)

  $outPath = Join-Path $outDir ($a.Slug + ".html")
  [System.IO.File]::WriteAllText($outPath, $page, (New-Object System.Text.UTF8Encoding($false)))
  Write-Host "Wrote $outPath"
}

Write-Host "Done: $($atvs.Count) pages generated."
