Add-Type -AssemblyName System.Drawing

$srcDir = "C:\Users\HI\Desktop\NYCATVS\images"
$maxDim = 900
$quality = 78

$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]$quality)

$files = Get-ChildItem -Path $srcDir -File | Where-Object { $_.Name -match '-[2-6]\.jpg$' }
$totalBefore = 0
$totalAfter = 0

foreach ($file in $files) {
  $before = $file.Length
  $totalBefore += $before

  $img = [System.Drawing.Image]::FromFile($file.FullName)
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

  $tmpPath = $file.FullName + ".tmp"
  $bmp.Save($tmpPath, $jpegCodec, $encParams)
  $bmp.Dispose()

  Move-Item -Force $tmpPath $file.FullName
  $after = (Get-Item $file.FullName).Length
  $totalAfter += $after
  Write-Host "$($file.Name): $w x $h (${before}B) -> $newW x $newH (${after}B)"
}

Write-Host "---"
Write-Host "Total: $([math]::Round($totalBefore/1MB,1))MB -> $([math]::Round($totalAfter/1MB,1))MB across $($files.Count) files"
