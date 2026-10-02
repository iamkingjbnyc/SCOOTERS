Add-Type -AssemblyName System.Drawing

$srcDir = "C:\Users\HI\Desktop\NYCATVS\images"
$maxDim = 900
$quality = 78

$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]$quality)

$names = @("rfne2plus","rfne2promax","rfnwarriorproe15","rfnaresrallypro","rfnwarrioryouthsxe5","rfnwarriorkidssxe350","rfnwarriorkidssxe500","v8max","evo20","evo16rfn","gts2000")

foreach ($name in $names) {
  $path = Join-Path $srcDir "$name.jpg"
  if (-not (Test-Path $path)) { Write-Host "MISSING: $name"; continue }
  $before = (Get-Item $path).Length

  $img = [System.Drawing.Image]::FromFile($path)
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

  $tmpPath = $path + ".tmp"
  $bmp.Save($tmpPath, $jpegCodec, $encParams)
  $bmp.Dispose()
  Move-Item -Force $tmpPath $path

  $after = (Get-Item $path).Length
  Write-Host "$name.jpg: $w x $h (${before}B) -> $newW x $newH (${after}B)"
}
