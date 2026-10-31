$ErrorActionPreference = 'Stop'
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$publicRoot = Join-Path $repoRoot 'public'
$checkedLinks = 0
function Assert-True($Condition, $Message) {
    if (-not $Condition) { throw $Message }
}
$files = @(Get-ChildItem -LiteralPath $publicRoot -Recurse -File)
Assert-True ($files.Count -gt 0) 'No public files found'
Assert-True (@($files | Where-Object Extension -eq '.html').Count -eq 1) 'Expected a single HTML page'
foreach ($file in $files) {
    Assert-True ($file.Extension -in @('.html', '.css', '.js', '.svg') -or $file.Name -in @('robots.txt', 'sitemap.xml')) "Unexpected public file: $($file.Name)"
    $text = [IO.File]::ReadAllText($file.FullName)
    Assert-True ($text -notmatch '\uFFFD') "Invalid encoding: $($file.Name)"
    Assert-True ($text -notmatch '(?i)(?:\+|00)32[\d\s().-]{8,}') "Potential phone number: $($file.Name)"
    Assert-True ($text -notmatch '-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----|gh[pousr]_[A-Za-z0-9]{30,}') "Potential secret: $($file.Name)"
    if ($file.Extension -ne '.html') { continue }
    Assert-True ($text -notmatch '(?i)\bdownload\s*(?:=|>)|<form\b|<iframe\b|\bonclick\s*=|\bstyle\s*=') "Unexpected active or download content: $($file.Name)"
    $ids = @([regex]::Matches($text, '\bid="([^"]+)"') | ForEach-Object { $_.Groups[1].Value })
    Assert-True (($ids | Select-Object -Unique).Count -eq $ids.Count) "Duplicate IDs: $($file.FullName)"
    Assert-True (([regex]::Matches($text, '<h1\b')).Count -eq 1) "Expected one h1: $($file.FullName)"
    Assert-True ($text -match '<html lang="(?:fr|en)"') 'Missing page language'
    Assert-True ($text -match '<select id="language"' -and $text -match 'value="fr"' -and $text -match 'value="en"' -and $text -match 'value="nl"') 'Missing three-language selector'
    Assert-True ($text -match 'name="description"' -and $text -match 'Content-Security-Policy') 'Missing metadata or CSP'
    foreach ($match in [regex]::Matches($text, '(?:href|src)="([^"]+)"')) {
        $link = $match.Groups[1].Value
        Assert-True ($link -notmatch '(?i)\.(?:pdf|docx?|odt|rtf)(?:$|[#?])|^(?:javascript:|data:|http:)') "Disallowed link: $link"
        if ($link -match '^https://') {
            Assert-True ($link -in @('https://www.linkedin.com/in/djieutcheusteve94', 'https://github.com/looker20', 'https://looker20.github.io/learn-github/')) "Unapproved external URL: $link"
            continue
        }
        if ($link -match '^mailto:') { continue }
        $segments = $link.Split('#', 2)
        $targetPath = $file.FullName
        if ($segments[0]) { $targetPath = [IO.Path]::GetFullPath((Join-Path $file.DirectoryName $segments[0])) }
        Assert-True ($targetPath.StartsWith($publicRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) "Link leaves public directory: $link"
        Assert-True ([IO.File]::Exists($targetPath)) "Broken link: $link"
        if ($segments.Count -eq 2) {
            $target = [IO.File]::ReadAllText($targetPath)
            Assert-True ($target.Contains('id="' + $segments[1] + '"')) "Missing anchor: $link"
        }
        $checkedLinks++
    }
}
Push-Location $repoRoot
try {
    $candidates = @(git -c core.quotepath=false ls-files --cached --others --exclude-standard)
    Assert-True ($LASTEXITCODE -eq 0) 'Cannot inspect Git files'
    foreach ($candidate in $candidates) {
        Assert-True ($candidate -notmatch '(?i)\.(?:pdf|docx?|odt|rtf|pem|key)$|(?:^|/)(?:private|\.private|\.local|cv)/') "Private file in Git candidates: $candidate"
    }
    git check-ignore --no-index --quiet -- 'private-source.docx'
    Assert-True ($LASTEXITCODE -eq 0) 'Private documents are not ignored'
} finally { Pop-Location }
Write-Output "PASS: $($files.Count) public files, $checkedLinks local references; languages, metadata, anchors and private-file exclusions checked."
