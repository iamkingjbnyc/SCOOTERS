Add-Type -AssemblyName System.Drawing

$srcDir = "C:\Users\HI\Desktop\NYCATVS\images"

# thumbnails shown small in category cards - shrink harder
$thumbMap = @{
  "images (16).jfif" = "scooter.jpg"
  "images (21).jfif" = "atv.jpg"
  "images (23).jfif" = "dirtbike.jpg"
  "go-kart.jfif"      = "go-kart.jpg"
  "utv.jfif"          = "utv.jpg"
  "ebike.jfif"        = "ebike.jpg"
  "images (18).jfif" = "full-inventory.jpg"
}
$thumbMaxDim = 440
$thumbQuality = 68

# larger feature images (hero, financing/service split) - keep more detail
$largeMap = @{
  "images (22).jfif" = "hero.jpg"
  "images (19).jfif" = "financing.jpg"
  "images (17).jfif" = "service.jpg"
}
$largeMaxDim = 700
$largeQuality = 78

$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }

function Optimize-Image($old, $new, $maxDim, $quality) {
  $srcPath = Join-Path $srcDir $old
  $dstPath = Join-Path $srcDir $new
  if (-not (Test-Path $srcPath)) { Write-Host "MISSING: $old"; return }

  $encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
  $encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]$quality)

  $img = [System.Drawing.Image]::FromFile($srcPath)
  $w = $img.Width
  $h = $img.Height
  $scale = [math]::Min(1.0, $maxDim / [math]::Max($w, $h))
  $newW = [int]([math]::Round($w * $scale))
  $newH = [int]([math]::Round($h * $scale))

  $bmp = New-Object System.Drawing.Bitmap($newW, $newH)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
  $g.DrawImage($img, 0, 0, $newW, $newH)
  $g.Dispose()
  $img.Dispose()

  $bmp.Save($dstPath, $jpegCodec, $encParams)
  $bmp.Dispose()

  $oldKB = [math]::Round((Get-Item $srcPath).Length / 1KB, 1)
  $newKB = [math]::Round((Get-Item $dstPath).Length / 1KB, 1)
  Write-Host "$old ($w x $h, ${oldKB}KB) -> $new ($newW x $newH, ${newKB}KB)"
}

foreach ($old in $thumbMap.Keys) { Optimize-Image $old $thumbMap[$old] $thumbMaxDim $thumbQuality }
foreach ($old in $largeMap.Keys) { Optimize-Image $old $largeMap[$old] $largeMaxDim $largeQuality }
