Add-Type -AssemblyName System.Drawing

$srcPath = "C:\Users\HI\Desktop\NYCATVS\images\logo-original.png"
$src = New-Object System.Drawing.Bitmap($srcPath)
$w = $src.Width
$h = $src.Height

# circular badge spans the full width; crop a centered square of side = width
$side = $w
$y0 = [int](($h - $side) / 2)
if ($y0 -lt 0) { $y0 = 0 }
if (($y0 + $side) -gt $h) { $side = $h - $y0 }

$cropRect = New-Object System.Drawing.Rectangle(0, $y0, $side, $side)
$cropped = $src.Clone($cropRect, $src.PixelFormat)
$src.Dispose()

$maxDim = 320
$scale = [math]::Min(1.0, $maxDim / $side)
$newDim = [int]([math]::Round($side * $scale))

$final = New-Object System.Drawing.Bitmap($newDim, $newDim)
$g = [System.Drawing.Graphics]::FromImage($final)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$g.DrawImage($cropped, 0, 0, $newDim, $newDim)
$g.Dispose()
$cropped.Dispose()

$outPath = "C:\Users\HI\Desktop\NYCATVS\images\logo.png"
$final.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$final.Dispose()

$kb = [math]::Round((Get-Item $outPath).Length / 1KB, 1)
Write-Host "Cropped y0=$y0 side=$side -> Saved $outPath ($newDim x $newDim, ${kb}KB)"
