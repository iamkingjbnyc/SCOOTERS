Add-Type -AssemblyName System.Drawing

$srcDir = "C:\Users\HI\Desktop\NYCATVS\images"
$maxDim = 320
$whiteThreshold = 232   # channel value where fade-to-transparent begins
$fullWhite = 250        # channel value at/above which pixel is fully transparent

$map = @{
  "images (16).jfif" = "scooter.png"
  "images (21).jfif" = "atv.png"
  "images (23).jfif" = "dirtbike.png"
  "go-kart.jfif"      = "go-kart.png"
  "utv.jfif"          = "utv.png"
  "ebike.jfif"        = "ebike.png"
  "images (18).jfif" = "full-inventory.png"
}

foreach ($old in $map.Keys) {
  $srcPath = Join-Path $srcDir $old
  $dstPath = Join-Path $srcDir $map[$old]
  if (-not (Test-Path $srcPath)) { Write-Host "MISSING: $old"; continue }

  $src = [System.Drawing.Image]::FromFile($srcPath)
  $w = $src.Width
  $h = $src.Height
  $scale = [math]::Min(1.0, $maxDim / [math]::Max($w, $h))
  $newW = [int]([math]::Round($w * $scale))
  $newH = [int]([math]::Round($h * $scale))

  $resized = New-Object System.Drawing.Bitmap($newW, $newH, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($resized)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.DrawImage($src, 0, 0, $newW, $newH)
  $g.Dispose()
  $src.Dispose()

  $rect = New-Object System.Drawing.Rectangle(0, 0, $newW, $newH)
  $bmpData = $resized.LockBits($rect, [System.Drawing.Imaging.ImageLockMode]::ReadWrite, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $bytes = $bmpData.Stride * $newH
  $pixels = New-Object byte[] $bytes
  [System.Runtime.InteropServices.Marshal]::Copy($bmpData.Scan0, $pixels, 0, $bytes)

  for ($y = 0; $y -lt $newH; $y++) {
    $rowStart = $y * $bmpData.Stride
    for ($x = 0; $x -lt $newW; $x++) {
      $i = $rowStart + $x * 4
      $b = $pixels[$i]
      $gr = $pixels[$i + 1]
      $r = $pixels[$i + 2]
      $minCh = [math]::Min($r, [math]::Min($gr, $b))
      if ($minCh -ge $fullWhite) {
        $pixels[$i + 3] = 0
      } elseif ($minCh -ge $whiteThreshold) {
        $frac = ($fullWhite - $minCh) / ($fullWhite - $whiteThreshold)
        $pixels[$i + 3] = [byte]([math]::Round(255 * $frac))
      }
    }
  }

  [System.Runtime.InteropServices.Marshal]::Copy($pixels, 0, $bmpData.Scan0, $bytes)
  $resized.UnlockBits($bmpData)

  $resized.Save($dstPath, [System.Drawing.Imaging.ImageFormat]::Png)
  $resized.Dispose()

  $newKB = [math]::Round((Get-Item $dstPath).Length / 1KB, 1)
  Write-Host "$old -> $($map[$old]) ($newW x $newH, ${newKB}KB, transparent bg)"
}
