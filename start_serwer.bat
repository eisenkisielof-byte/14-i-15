@echo off
cd /d %~dp0

echo ======================================
echo   LOKALNY SERWER KISIELOW — PORT 8000
echo ======================================

powershell -NoExit -Command ^
  Add-Type -AssemblyName System.Net.HttpListener; ^
  $h = New-Object System.Net.HttpListener; ^
  $h.Prefixes.Add('http://localhost:8000/'); ^
  $h.Start(); ^
  Write-Host 'Serwer działa na: http://localhost:8000/index.html'; ^
  while ($true) { ^
      $ctx = $h.GetContext(); ^
      $req = $ctx.Request; ^
      $res = $ctx.Response; ^
      $path = $req.Url.LocalPath.TrimStart('/'); ^
      if ($path -eq '') { $path = 'index.html' }; ^
      if (Test-Path $path) { ^
          $ext = [System.IO.Path]::GetExtension($path); ^
          switch ($ext) { ^
              ".html" { $res.ContentType = "text/html" } ^
              ".htm"  { $res.ContentType = "text/html" } ^
              ".png"  { $res.ContentType = "image/png" } ^
              ".jpg"  { $res.ContentType = "image/jpeg" } ^
              ".gif"  { $res.ContentType = "image/gif" } ^
              ".css"  { $res.ContentType = "text/css" } ^
              ".js"   { $res.ContentType = "application/javascript" } ^
              default { $res.ContentType = "application/octet-stream" } ^
          }; ^
          $bytes = [System.IO.File]::ReadAllBytes($path); ^
          $res.OutputStream.Write($bytes, 0, $bytes.Length); ^
      } else { ^
          $res.StatusCode = 404; ^
      }; ^
      $res.Close(); ^
  }
