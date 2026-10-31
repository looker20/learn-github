param([ValidateRange(1024, 65535)][int]$Port = 8080)
$ErrorActionPreference = 'Stop'
$publicRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\public'))
$listener = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, $Port)
$listener.Start()
Write-Output "Portfolio: http://127.0.0.1:$Port/ (Ctrl+C pour arrêter)"
try {
    while ($true) {
        $client = $listener.AcceptTcpClient()
        try {
            $client.ReceiveTimeout = 3000
            $stream = $client.GetStream()
            $reader = [IO.StreamReader]::new($stream, [Text.Encoding]::ASCII, $false, 1024, $true)
            $request = $reader.ReadLine()
            if (-not $request) { continue }
            while ($reader.ReadLine()) { }
            $parts = $request.Split(' ')
            $status = '200 OK'
            $contentType = 'text/plain; charset=utf-8'
            $body = [Text.Encoding]::UTF8.GetBytes('Not found')
            $method = $parts[0]
            if ($method -notin @('GET', 'HEAD')) { $status = '405 Method Not Allowed' }
            else {
                $route = [Uri]::UnescapeDataString(($parts[1] -split '\?')[0])
                # A second mount permits testing deployment below a path prefix.
                if ($route.StartsWith('/portfolio/')) { $route = $route.Substring(10) }
                if ($route.EndsWith('/')) { $route += 'index.html' }
                $relative = $route.TrimStart('/').Replace('/', [IO.Path]::DirectorySeparatorChar)
                $file = [IO.Path]::GetFullPath((Join-Path $publicRoot $relative))
                if (-not $file.StartsWith($publicRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
                    $status = '403 Forbidden'
                } elseif ([IO.File]::Exists($file)) {
                    $body = [IO.File]::ReadAllBytes($file)
                    switch ([IO.Path]::GetExtension($file)) {
                        '.html' { $contentType = 'text/html; charset=utf-8' }
                        '.css' { $contentType = 'text/css; charset=utf-8' }
                        '.js' { $contentType = 'text/javascript; charset=utf-8' }
                        '.svg' { $contentType = 'image/svg+xml' }
                    }
                } else { $status = '404 Not Found' }
            }
            $headers = @(
                "HTTP/1.1 $status", "Content-Type: $contentType", "Content-Length: $($body.Length)",
                'Connection: close', 'Cache-Control: no-store', 'X-Content-Type-Options: nosniff',
                'X-Frame-Options: DENY', 'Referrer-Policy: strict-origin-when-cross-origin',
                'Permissions-Policy: camera=(), microphone=(), geolocation=()',
                "Content-Security-Policy: default-src 'none'; style-src 'self'; script-src 'self'; img-src 'self'; font-src 'self'; connect-src 'none'; object-src 'none'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'"
            ) -join "`r`n"
            $headerBytes = [Text.Encoding]::ASCII.GetBytes($headers + "`r`n`r`n")
            $stream.Write($headerBytes, 0, $headerBytes.Length)
            if ($method -ne 'HEAD') { $stream.Write($body, 0, $body.Length) }
        } catch { Write-Warning $_.Exception.Message }
        finally { $client.Dispose() }
    }
} finally { $listener.Stop() }
