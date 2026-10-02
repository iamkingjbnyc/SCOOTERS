# Creates Stripe Products, Prices, and Payment Links for NYC ATV Warehouse's fixed-price inventory.
# Reads STRIPE_SECRET_KEY_TEST or STRIPE_SECRET_KEY_LIVE from .env based on -Mode.
# Writes results to stripe_links.<mode>.json (gitignored).

param(
  [ValidateSet("test", "live")]
  [string]$Mode = "test"
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$envVarName = if ($Mode -eq "live") { "STRIPE_SECRET_KEY_LIVE" } else { "STRIPE_SECRET_KEY_TEST" }
$envContent = Get-Content (Join-Path $root ".env") -Raw
$key = (($envContent -split "`n") | Where-Object { $_ -match "^$envVarName=" }) -replace "^$envVarName=", ''
$key = $key.Trim()
if ($Mode -eq "live" -and $key -notmatch '^sk_live_') { throw "Refusing to continue: -Mode live but STRIPE_SECRET_KEY_LIVE is not a live key." }
if ($Mode -eq "test" -and $key -notmatch '^sk_test_') { throw "Refusing to continue: -Mode test but STRIPE_SECRET_KEY_TEST is not a test key." }
Write-Host "Mode: $Mode"
$authHeader = @{ Authorization = "Basic " + [Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($key):")) }
$depositCents = 20000  # $200.00 deposit

# name, file (category page), price in USD, mode: "full" or "deposit"
$products = @(
  # E-bikes (under $1000 -> full price)
  @{ name = "SPARK 48V"; file = "ebikes.html"; price = 599; mode = "full" }
  @{ name = "OUXI V8"; file = "ebikes.html"; price = 749; mode = "full" }
  @{ name = "GT06 E-Scooter"; file = "ebikes.html"; price = 599; mode = "full" }
  @{ name = "RFN EVO 18"; file = "ebikes.html"; price = 1099; mode = "deposit" }
  @{ name = "OUXI GT-2000"; file = "ebikes.html"; price = 1299; mode = "deposit" }

  # Scooters
  @{ name = "VIPER VTR 150cc"; file = "scooters.html"; price = 799; mode = "full" }
  @{ name = "Tank Pro X200 Elite"; file = "scooters.html"; price = 1299; mode = "deposit" }
  @{ name = "Tank Defender 150"; file = "scooters.html"; price = 1099; mode = "deposit" }
  @{ name = "Marchal X200 Delivery Edition"; file = "scooters.html"; price = 1299; mode = "deposit" }
  @{ name = "Intrepid 200"; file = "scooters.html"; price = 1399; mode = "deposit" }

  # ATVs
  @{ name = "Cyber Roamer 300 EFI"; file = "atvs.html"; price = 5499; mode = "deposit" }
  @{ name = "Pentora Hunter 200 EFI"; file = "atvs.html"; price = 2499; mode = "deposit" }
  @{ name = "Pentora Sport 250cc"; file = "atvs.html"; price = 2599; mode = "deposit" }
  @{ name = "Commander 200cc"; file = "atvs.html"; price = 2499; mode = "deposit" }
  @{ name = "Cougar UT 200cc"; file = "atvs.html"; price = 2299; mode = "deposit" }
  @{ name = "Cougar Sport 200cc"; file = "atvs.html"; price = 2499; mode = "deposit" }
  @{ name = "Pentora 200 EFI"; file = "atvs.html"; price = 2499; mode = "deposit" }
  @{ name = "Pentora Iride 125cc"; file = "atvs.html"; price = 1499; mode = "deposit" }
  @{ name = "Pentora 125cc"; file = "atvs.html"; price = 1599; mode = "deposit" }
  @{ name = "Falcon X 125cc"; file = "atvs.html"; price = 1499; mode = "deposit" }
  @{ name = "Commander 125cc"; file = "atvs.html"; price = 1499; mode = "deposit" }
  @{ name = "Blazer 9 125cc"; file = "atvs.html"; price = 1499; mode = "deposit" }
  @{ name = "Racer 125cc"; file = "atvs.html"; price = 1499; mode = "deposit" }
  @{ name = "Rider 10 - 125cc"; file = "atvs.html"; price = 1499; mode = "deposit" }
  @{ name = "Mini Commander 110cc"; file = "atvs.html"; price = 1399; mode = "deposit" }
  @{ name = "RXR 110cc"; file = "atvs.html"; price = 1399; mode = "deposit" }
)

function Invoke-StripeForm($url, $formPairs) {
  $body = ($formPairs.GetEnumerator() | ForEach-Object { "$([uri]::EscapeDataString($_.Key))=$([uri]::EscapeDataString($_.Value))" }) -join "&"
  return Invoke-RestMethod -Uri $url -Method Post -Headers $authHeader -ContentType "application/x-www-form-urlencoded" -Body $body
}

$results = @()
$i = 0
foreach ($p in $products) {
  $i++
  Write-Host "[$i/$($products.Count)] $($p.name) ($($p.file), $($p.mode), `$$($p.price))"

  if ($p.mode -eq "deposit") {
    $desc = "Refundable `$200 deposit to reserve the $($p.name) (total price `$$($p.price)). Balance due at pickup; financing available."
    $amountCents = $depositCents
    $submitMsg = "Deposit received for the $($p.name). We will contact you within 1 business day to arrange financing, pickup, or delivery. The remaining `$$($p.price - 200) balance is due at pickup."
  } else {
    $desc = "$($p.name) - full purchase price `$$($p.price)."
    $amountCents = $p.price * 100
    $submitMsg = "Thanks for your purchase of the $($p.name)! We will contact you within 1 business day to schedule pickup or delivery."
  }

  $product = Invoke-StripeForm "https://api.stripe.com/v1/products" @{
    "name" = $p.name
    "description" = $desc
  }

  $price = Invoke-StripeForm "https://api.stripe.com/v1/prices" @{
    "product" = $product.id
    "unit_amount" = "$amountCents"
    "currency" = "usd"
  }

  $linkBody = @{
    "line_items[0][price]" = $price.id
    "line_items[0][quantity]" = "1"
    "after_completion[type]" = "hosted_confirmation"
    "after_completion[hosted_confirmation][custom_message]" = $submitMsg
  }
  $link = Invoke-StripeForm "https://api.stripe.com/v1/payment_links" $linkBody

  $results += [PSCustomObject]@{
    name = $p.name
    file = $p.file
    price = $p.price
    mode = $p.mode
    product_id = $product.id
    price_id = $price.id
    payment_link = $link.url
  }
}

$outFile = "stripe_links.$Mode.json"
$results | ConvertTo-Json -Depth 5 | Set-Content -Path (Join-Path $root $outFile) -Encoding utf8
Write-Host "`nDone. Wrote $(($results).Count) payment links to $outFile"
