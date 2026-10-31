param([string]$BaseUrl = 'http://127.0.0.1:8080', [switch]$Deployed)
$ErrorActionPreference = 'Stop'
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$outputDir = Join-Path $repoRoot '.local'
[IO.Directory]::CreateDirectory($outputDir) | Out-Null
$browserPath = @(
    'C:\Program Files\Google\Chrome\Application\chrome.exe',
    'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if (-not $browserPath) { throw 'Chrome or Edge is required for browser checks.' }
$profilePath = Join-Path $outputDir ('browser-' + [Guid]::NewGuid().ToString('N'))
$browserProcess = $null
$script:socket = $null
$script:commandId = 0
$script:errors = [Collections.Generic.List[string]]::new()
$script:externalRequests = [Collections.Generic.List[string]]::new()
$results = [Collections.Generic.List[string]]::new()
function Assert-True($Condition, $Message) { if (-not $Condition) { throw $Message } }
function Invoke-CDP([string]$Method, $Parameters = @{}) {
    $script:commandId++
    $id = $script:commandId
    $json = @{ id = $id; method = $Method; params = $Parameters } | ConvertTo-Json -Depth 20 -Compress
    $bytes = [Text.Encoding]::UTF8.GetBytes($json)
    $timeout = [Threading.CancellationTokenSource]::new(15000)
    try {
        $script:socket.SendAsync([ArraySegment[byte]]::new($bytes), [Net.WebSockets.WebSocketMessageType]::Text, $true, $timeout.Token).GetAwaiter().GetResult() | Out-Null
        while ($true) {
            $message = [IO.MemoryStream]::new()
            try {
                do {
                    $buffer = [byte[]]::new(65536)
                    $received = $script:socket.ReceiveAsync([ArraySegment[byte]]::new($buffer), $timeout.Token).GetAwaiter().GetResult()
                    $message.Write($buffer, 0, $received.Count)
                } while (-not $received.EndOfMessage)
                $reply = [Text.Encoding]::UTF8.GetString($message.ToArray()) | ConvertFrom-Json
            } finally { $message.Dispose() }
            if ($reply.method -eq 'Runtime.exceptionThrown') { $script:errors.Add(($reply.params | ConvertTo-Json -Depth 8 -Compress)) }
            if ($reply.method -eq 'Log.entryAdded' -and $reply.params.entry.level -eq 'error') { $script:errors.Add($reply.params.entry.text) }
            if ($reply.method -eq 'Network.requestWillBeSent') {
                $requestUrl = $reply.params.request.url
                if ($requestUrl -match '^https?://' -and -not $requestUrl.StartsWith($BaseUrl + '/')) { $script:externalRequests.Add($requestUrl) }
            }
            if ($reply.id -eq $id) {
                if ($reply.error) { throw ($reply.error | ConvertTo-Json -Compress) }
                return $reply.result
            }
        }
    } finally { $timeout.Dispose() }
}
function Evaluate([string]$Expression) {
    $result = Invoke-CDP 'Runtime.evaluate' @{ expression = $Expression; returnByValue = $true; awaitPromise = $true }
    if ($result.exceptionDetails) { throw ($result.exceptionDetails | ConvertTo-Json -Depth 8 -Compress) }
    return $result.result.value
}
function Navigate([string]$Url) {
    Invoke-CDP 'Page.navigate' @{ url = $Url } | Out-Null
    for ($attempt = 0; $attempt -lt 50; $attempt++) {
        Start-Sleep -Milliseconds 100
        if (Evaluate 'document.readyState === "complete" && !!document.querySelector(".hero")') { return }
    }
    throw "Page not ready: $Url"
}
function Press-Key([string]$Key, [string]$Code, [int]$VirtualKey) {
    $keyDown = @{ type = 'keyDown'; key = $Key; code = $Code; windowsVirtualKeyCode = $VirtualKey }
    if ($Key -eq 'Enter') { $keyDown.text = "`r"; $keyDown.unmodifiedText = "`r" }
    Invoke-CDP 'Input.dispatchKeyEvent' $keyDown | Out-Null
    Invoke-CDP 'Input.dispatchKeyEvent' @{ type = 'keyUp'; key = $Key; code = $Code; windowsVirtualKeyCode = $VirtualKey } | Out-Null
}
function Switch-Language([ValidateSet('fr', 'en', 'nl')][string]$Language) {
    Open-Menu
    $samePage = Evaluate "(() => { const main = document.querySelector('main'), url = location.href, select = document.querySelector('#language'); select.focus(); select.value = '$Language'; select.dispatchEvent(new Event('change', { bubbles: true })); return main === document.querySelector('main') && url === location.href && document.activeElement === select; })()"
    Assert-True $samePage 'Language change replaced the page, URL or focus'
}
function Switch-Theme([ValidateSet('light', 'dark')][string]$Theme) {
    Open-Menu
    $samePage = Evaluate "(() => { const main = document.querySelector('main'), url = location.href, select = document.querySelector('#theme'); select.focus(); select.value = '$Theme'; select.dispatchEvent(new Event('change', { bubbles: true })); return main === document.querySelector('main') && url === location.href && document.activeElement === select && document.documentElement.dataset.theme === '$Theme'; })()"
    Assert-True $samePage 'Theme change failed or replaced page, URL or focus'
}
function Open-Menu {
    Evaluate 'if (!matchMedia("(min-width: 1024px)").matches && document.querySelector(".menu-toggle").getAttribute("aria-expanded") !== "true") document.querySelector(".menu-toggle").click()' | Out-Null
}
function Close-Menu {
    Evaluate 'if (document.querySelector(".menu-toggle").getAttribute("aria-expanded") === "true") document.querySelector(".menu-toggle").click()' | Out-Null
}
function Test-ResponsiveFocus {
    Invoke-CDP 'Emulation.setDeviceMetricsOverride' @{ width = 900; height = 900; deviceScaleFactor = 1; mobile = $false } | Out-Null
    Navigate ($BaseUrl + '/index.html')
    Evaluate 'window.focusTrace = []; for (const type of ["focusin", "focusout"]) document.addEventListener(type, event => focusTrace.push({type, target:event.target.id || event.target.tagName, related:event.relatedTarget?.id || event.relatedTarget?.tagName, desktop:matchMedia("(min-width: 1024px)").matches})); matchMedia("(min-width: 1024px)").addEventListener("change", event => focusTrace.push({type:"media",desktop:event.matches,active:document.activeElement.id || document.activeElement.tagName}));' | Out-Null
    Open-Menu
    Evaluate 'document.querySelector("#theme").focus()' | Out-Null
    Invoke-CDP 'Emulation.setDeviceMetricsOverride' @{ width = 1024; height = 900; deviceScaleFactor = 1; mobile = $false } | Out-Null
    Evaluate 'new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve)))' | Out-Null
    Assert-True (Evaluate 'getComputedStyle(document.querySelector(".menu-toggle")).display === "none" && document.activeElement.matches("#theme") && getComputedStyle(document.querySelector("#navigation")).display !== "none"') 'Resizing to desktop lost visible settings or focus'
    Invoke-CDP 'Emulation.setDeviceMetricsOverride' @{ width = 900; height = 900; deviceScaleFactor = 1; mobile = $false } | Out-Null
    Evaluate 'new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve)))' | Out-Null
    Assert-True (Evaluate 'document.activeElement.matches(".menu-toggle") && document.querySelector(".menu-toggle").getAttribute("aria-expanded") === "false" && getComputedStyle(document.querySelector("#navigation")).display === "none"') 'Resizing to mobile left focus inside a hidden menu'
    Invoke-CDP 'Emulation.setDeviceMetricsOverride' @{ width = 1280; height = 900; deviceScaleFactor = 1; mobile = $false } | Out-Null
    Evaluate 'new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve)))' | Out-Null
    Assert-True (Evaluate 'document.activeElement.matches("#navigation a")') 'Resize left focus on the hidden mobile toggle'
    $results.Add('PASS responsive breakpoint transitions preserve visible keyboard focus')
}
try {
    $arguments = @('--headless=new', '--disable-gpu', '--no-first-run', '--no-default-browser-check', '--remote-debugging-port=0', ('--user-data-dir="' + $profilePath + '"'), 'about:blank')
    $browserProcess = Start-Process -FilePath $browserPath -ArgumentList $arguments -WindowStyle Hidden -PassThru
    $portFile = Join-Path $profilePath 'DevToolsActivePort'
    for ($attempt = 0; $attempt -lt 80 -and -not (Test-Path -LiteralPath $portFile); $attempt++) { Start-Sleep -Milliseconds 100 }
    Assert-True (Test-Path -LiteralPath $portFile) 'Browser debugging endpoint did not start.'
    $debugPort = (Get-Content -LiteralPath $portFile)[0]
    $tabs = Invoke-RestMethod "http://127.0.0.1:$debugPort/json/list"
    $tab = $tabs | Where-Object type -eq 'page' | Select-Object -First 1
    $script:socket = [Net.WebSockets.ClientWebSocket]::new()
    $script:socket.ConnectAsync([Uri]$tab.webSocketDebuggerUrl, [Threading.CancellationToken]::None).GetAwaiter().GetResult() | Out-Null
    foreach ($domain in @('Page.enable', 'Runtime.enable', 'Log.enable', 'Network.enable')) { Invoke-CDP $domain | Out-Null }
    Invoke-CDP 'Emulation.setFocusEmulationEnabled' @{ enabled = $true } | Out-Null
    Test-ResponsiveFocus
    $prefixes = if ($Deployed) { @('') } else { @('', '/portfolio') }
    foreach ($prefix in $prefixes) {
        foreach ($theme in @('light', 'dark')) {
        foreach ($language in @('fr', 'en', 'nl')) {
            $path = '/index.html'
            foreach ($width in @(320, 360, 390, 640, 768, 900, 1023, 1024, 1280)) {
                Invoke-CDP 'Emulation.setDeviceMetricsOverride' @{ width = $width; height = 900; deviceScaleFactor = 1; mobile = ($width -le 640) } | Out-Null
                Navigate ($BaseUrl + $prefix + $path)
                Assert-True (Evaluate 'document.querySelector(".site-header").getBoundingClientRect().height < 90 && (innerWidth >= 1024 ? getComputedStyle(document.querySelector(".menu-toggle")).display === "none" && getComputedStyle(document.querySelector("#navigation")).display !== "none" && document.querySelector("#language").getClientRects().length > 0 && document.querySelector("#theme").getClientRects().length > 0 : document.querySelector(".menu-toggle").getAttribute("aria-expanded") === "false" && getComputedStyle(document.querySelector("#navigation")).display === "none" && document.querySelector("#language").getClientRects().length === 0 && document.querySelector("#theme").getClientRects().length === 0)') 'Desktop navigation is hidden or mobile settings leak out of the menu'
                Switch-Language $language
                Switch-Theme $theme
                Assert-True (Evaluate 'document.querySelector("#navigation").contains(document.querySelector("#language")) && document.querySelector("#navigation").contains(document.querySelector("#theme")) && document.querySelector("#navigation").getBoundingClientRect().left >= 0 && document.querySelector("#navigation").getBoundingClientRect().right <= innerWidth && document.querySelector("#navigation").scrollWidth <= document.querySelector("#navigation").clientWidth') 'Unified menu does not contain its settings or overflows'
                if ($width -ge 1024) {
                    Assert-True (Evaluate '(() => { const nodes = [...document.querySelectorAll("#navigation a"), document.querySelector("#language"), document.querySelector("#theme")]; const centers = nodes.map(node => { const rect = node.getBoundingClientRect(); return rect.top + rect.height / 2; }); return Math.max(...centers) - Math.min(...centers) < 2; })()') 'Desktop navigation and settings are not in one horizontal row'
                }
                Assert-True (Evaluate '!!document.querySelector(".brand-symbol path") && !document.querySelector(".brand-mark").textContent.trim()') 'New vector logo is missing or old initials remain'
                Assert-True ((Evaluate 'document.documentElement.lang') -eq $language) 'Incorrect language'
                Assert-True (Evaluate 'Object.keys(portfolioTranslations.en).every(key => typeof portfolioTranslations.nl[key] === "string" && portfolioTranslations.nl[key].length > 0)') 'Incomplete translation catalogue'
                $expectedHeading = @{ fr = 'Comprendre les'; en = 'Understand systems'; nl = 'Systemen begrijpen' }[$language]
                Assert-True ((Evaluate 'document.querySelector("h1").textContent').Contains($expectedHeading)) 'Heading translation failed'
                $expectedLabel = @{ fr = 'Choisir la langue'; en = 'Choose language'; nl = 'Kies de taal' }[$language]
                Assert-True ((Evaluate 'document.querySelector("label[for=language]").textContent') -eq $expectedLabel) 'Accessible language label not translated'
                $expectedAlt = @{ fr = 'Portrait professionnel de Steve Aimé'; en = 'Professional portrait of Steve Aimé'; nl = 'Professioneel portret van Steve Aimé' }[$language]
                Assert-True ((Evaluate 'document.querySelector(".portrait-frame img").alt') -eq $expectedAlt) 'Portrait alternative text not translated'
                Assert-True (Evaluate 'document.querySelector(".portrait-frame img").complete && document.querySelector(".portrait-frame img").naturalWidth === 1372 && document.querySelector(".portrait-frame img").naturalHeight === 1372 && !document.querySelector(".portrait-stamp")') 'LinkedIn portrait did not load or has a monogram'
                $overflow = Evaluate '({width:innerWidth,scroll:document.documentElement.scrollWidth})'
                Assert-True ($overflow.scroll -le $overflow.width) "Horizontal overflow: $language $prefix $width"
                Assert-True (Evaluate 'Array.from(document.styleSheets).some(s => s.cssRules.length > 20)') 'Stylesheet not loaded'
                Assert-True (Evaluate 'document.querySelectorAll("main section").length === 6') 'Missing sections'
                Assert-True (Evaluate 'document.querySelectorAll("[download],form,iframe").length === 0') 'Unexpected public feature'
                Assert-True (Evaluate 'document.querySelectorAll("[data-project-state=delivered]").length === 2 && document.querySelectorAll("[data-project-state=ongoing]").length === 1 && document.querySelector("[data-summary-filter=delivered] strong").textContent === "2" && document.querySelector("[data-summary-filter=ongoing] strong").textContent === "1"') 'Project status counters differ from confirmed facts'
                Assert-True (Evaluate 'Array.from(document.querySelectorAll("body *")).filter(el => el.getClientRects().length && Array.from(el.childNodes).some(node => node.nodeType === 3 && node.textContent.trim())).every(el => parseFloat(getComputedStyle(el).fontSize) >= 14)') 'Text below the minimum readable size'
                $contrastFailures = Evaluate @'
(() => {
  const rgb = value => (value.match(/[\d.]+/g) || []).map(Number);
  const luminance = channels => channels.slice(0, 3).map(v => { v /= 255; return v <= .04045 ? v / 12.92 : ((v + .055) / 1.055) ** 2.4; }).reduce((sum, v, i) => sum + v * [.2126, .7152, .0722][i], 0);
  return Array.from(document.querySelectorAll('body *')).filter(el => el.getClientRects().length && Array.from(el.childNodes).some(n => n.nodeType === 3 && n.textContent.trim())).flatMap(el => {
    const style = getComputedStyle(el);
    let parent = el, background;
    while (parent) { const color = rgb(getComputedStyle(parent).backgroundColor); if (color.length === 3 || color[3] === 1) { background = color; break; } parent = parent.parentElement; }
    const values = [luminance(rgb(style.color)), luminance(background || [255, 255, 255])].sort((a, b) => b - a);
    const ratio = (values[0] + .05) / (values[1] + .05);
    const large = parseFloat(style.fontSize) >= 24 || (parseFloat(style.fontSize) >= 18.66 && parseInt(style.fontWeight, 10) >= 700);
    return ratio + .01 < (large ? 3 : 4.5) ? [{text: el.textContent.trim().slice(0, 55), ratio}] : [];
  });
})()
'@
                Assert-True (@($contrastFailures).Count -eq 0) ('Text contrast failed: ' + ($contrastFailures | ConvertTo-Json -Compress))
                if (-not $prefix -and $language -eq 'fr' -and $width -in @(360, 1280)) {
                    $menuImage = Invoke-CDP 'Page.captureScreenshot' @{ format = 'png'; captureBeyondViewport = $false }
                    [IO.File]::WriteAllBytes((Join-Path $outputDir "menu-$theme-$width.png"), [Convert]::FromBase64String($menuImage.data))
                }
                Close-Menu
                Evaluate 'document.querySelector("[data-project-filter=network]").focus()' | Out-Null
                Press-Key 'Enter' 'Enter' 13
                Assert-True (Evaluate 'document.querySelectorAll("[data-project-topic]:not([hidden])").length === 2 && document.querySelector("[data-project-filter=network]").getAttribute("aria-pressed") === "true"') 'Keyboard project filter failed'
                $otherLanguage = @{ fr = 'en'; en = 'nl'; nl = 'fr' }[$language]
                Switch-Language $otherLanguage
                Assert-True (Evaluate 'document.querySelectorAll("[data-project-topic]:not([hidden])").length === 2') 'Translation lost active filter'
                Switch-Language $language
                $expectedResult = @{ fr = '2 réalisations affichées.'; en = '2 projects shown.'; nl = '2 projecten weergegeven.' }[$language]
                Assert-True ((Evaluate 'document.querySelector("#project-status").textContent') -eq $expectedResult) 'Accessible filter status not translated'
                Assert-True ((Evaluate 'document.documentElement.dataset.theme') -eq $theme) 'Language change lost theme'
                Evaluate 'document.querySelector("[data-project-filter=observability]").click()' | Out-Null
                Assert-True (Evaluate 'document.querySelectorAll("[data-project-topic]:not([hidden])").length === 2 && document.querySelector("[data-project-group=academic]").hidden') 'Observability filter failed'
                Evaluate 'document.querySelector("[data-summary-filter=delivered]").click()' | Out-Null
                Assert-True (Evaluate 'document.querySelectorAll("[data-project-topic]:not([hidden])").length === 2 && Array.from(document.querySelectorAll("[data-project-topic]:not([hidden])")).every(p => p.dataset.projectState === "delivered")') 'Delivered-project summary filter failed'
                Evaluate 'document.querySelector("[data-summary-filter=ongoing]").click()' | Out-Null
                Assert-True (Evaluate 'document.querySelectorAll("[data-project-topic]:not([hidden])").length === 1 && document.querySelector("[data-project-topic=ai]").hidden === false') 'Ongoing-project summary filter failed'
                Evaluate 'document.querySelector("[data-project-filter=all]").click()' | Out-Null
                Assert-True (Evaluate 'document.querySelectorAll("[data-project-topic]:not([hidden])").length === 5 && !document.querySelector("[data-project-group=academic]").hidden') 'All-projects filter failed'
                Close-Menu
                if ($width -lt 1024) {
                Evaluate 'document.querySelector(".menu-toggle").focus()' | Out-Null
                Press-Key 'Enter' 'Enter' 13
                Assert-True (Evaluate 'document.querySelector(".menu-toggle").getAttribute("aria-expanded") === "true" && getComputedStyle(document.querySelector("#navigation")).display !== "none"') 'Keyboard menu open failed'
                Press-Key 'Tab' 'Tab' 9
                Assert-True (Evaluate 'document.activeElement.matches("#navigation a")') 'Menu links not reachable by Tab'
                for ($tabIndex = 0; $tabIndex -lt 5; $tabIndex++) { Press-Key 'Tab' 'Tab' 9 }
                Assert-True (Evaluate 'document.activeElement.matches("#language")') 'Language selector not reachable by Tab'
                Press-Key 'Tab' 'Tab' 9
                Assert-True (Evaluate 'document.activeElement.matches("#theme")') 'Theme selector not reachable by Tab'
                Press-Key 'Escape' 'Escape' 27
                Assert-True (Evaluate 'document.activeElement.matches(".menu-toggle") && document.activeElement.getAttribute("aria-expanded") === "false"') 'Menu escape/focus failed'
                Open-Menu
                Evaluate 'document.querySelector("#theme").focus()' | Out-Null
                Press-Key 'Tab' 'Tab' 9
                Assert-True (Evaluate 'document.querySelector(".menu-toggle").getAttribute("aria-expanded") === "false" && !document.activeElement.closest("#navigation")') 'Leaving menu by Tab did not close it or lost focus'
                Evaluate 'document.querySelector(".menu-toggle").click(); document.querySelector("#navigation a").click()' | Out-Null
                Assert-True (Evaluate 'location.hash === "#about" && document.querySelector(".menu-toggle").getAttribute("aria-expanded") === "false"') 'Menu anchor failed'
                Open-Menu
                Evaluate 'document.querySelector(".hero-role").click()' | Out-Null
                Assert-True (Evaluate 'document.querySelector(".menu-toggle").getAttribute("aria-expanded") === "false"') 'Outside click did not close menu'
                } else {
                    Evaluate 'document.querySelector("#navigation a").focus()' | Out-Null
                    for ($tabIndex = 0; $tabIndex -lt 5; $tabIndex++) { Press-Key 'Tab' 'Tab' 9 }
                    Assert-True (Evaluate 'document.activeElement.matches("#language")') 'Desktop language selector not reachable by Tab'
                    Press-Key 'Tab' 'Tab' 9
                    Assert-True (Evaluate 'document.activeElement.matches("#theme")') 'Desktop theme selector not reachable by Tab'
                    Press-Key 'Escape' 'Escape' 27
                    Assert-True (Evaluate 'getComputedStyle(document.querySelector("#navigation")).display !== "none" && document.activeElement.matches("#theme")') 'Escape hid desktop navigation or lost focus'
                }
                Evaluate 'document.querySelector("summary").focus()' | Out-Null
                Press-Key 'Enter' 'Enter' 13
                Assert-True (Evaluate 'document.querySelector("details").open') 'Project details keyboard interaction failed'
                Evaluate 'document.querySelector("details").open = false; window.scrollTo({top: document.documentElement.scrollHeight, behavior: "instant"})' | Out-Null
                Evaluate 'new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve)))' | Out-Null
                Assert-True (Evaluate 'document.querySelector(".reading-progress").value > 95') 'Reading progress not updated'
                Assert-True (Evaluate '!!document.querySelector("#navigation a[aria-current=location]")') 'Current section not indicated'
                Assert-True (Evaluate 'Math.abs(document.querySelector(".site-header").getBoundingClientRect().top) < 1') 'Header does not stay at the top while scrolling'
                if ($width -ge 1024) {
                    Assert-True (Evaluate 'document.querySelector("#language").getBoundingClientRect().top >= 0 && document.querySelector("#theme").getBoundingClientRect().bottom < 90 && getComputedStyle(document.querySelector("#navigation")).display !== "none"') 'Desktop settings disappear while scrolling'
                }
                Evaluate 'document.activeElement.blur(); window.scrollTo({top: 0, behavior: "instant"})' | Out-Null
                Evaluate 'Promise.all(document.getAnimations().map(animation => animation.finished.catch(() => {}))).then(() => true)' | Out-Null
                $suffix = if ($prefix) { '-prefix' } else { '' }
                $screenshot = Invoke-CDP 'Page.captureScreenshot' @{ format = 'png'; captureBeyondViewport = $false }
                [IO.File]::WriteAllBytes((Join-Path $outputDir "$language-$theme-$width$suffix.png"), [Convert]::FromBase64String($screenshot.data))
                if (-not $prefix -and $width -eq 1280) {
                    $metrics = Invoke-CDP 'Page.getLayoutMetrics'
                    $fullImage = Invoke-CDP 'Page.captureScreenshot' @{ format = 'png'; captureBeyondViewport = $true; clip = @{ x = 0; y = 0; width = 1280; height = $metrics.cssContentSize.height; scale = 1 } }
                    [IO.File]::WriteAllBytes((Join-Path $outputDir "$language-$theme-full.png"), [Convert]::FromBase64String($fullImage.data))
                }
                $results.Add("PASS $language $theme $prefix width=$width : sticky horizontal desktop navigation, mobile menu, logo, layout, contrast and keyboard")
            }
            Evaluate 'document.querySelector("details").open = true; window.location.hash = "projects"' | Out-Null
            Switch-Language $language
            Assert-True (Evaluate 'document.querySelector("details").open && location.hash === "#projects"') 'Language switch lost section state'
            Navigate ($BaseUrl + $prefix + $path)
            Assert-True ((Evaluate 'document.documentElement.lang') -eq $language) 'Saved preference lost after reload'
            Assert-True ((Evaluate 'document.documentElement.dataset.theme') -eq $theme) 'Saved theme lost after reload'
        }
        }
    }
    foreach ($scenario in @(
        @{ system = 'dark'; saved = ''; expected = 'dark' },
        @{ system = 'light'; saved = 'invalid'; expected = 'light' },
        @{ system = 'dark'; saved = 'light'; expected = 'light' }
    )) {
        $saved = $scenario.saved
        Evaluate "localStorage.setItem('portfolio-theme', '$saved')" | Out-Null
        Invoke-CDP 'Emulation.setEmulatedMedia' @{ features = @(@{ name = 'prefers-color-scheme'; value = $scenario.system }) } | Out-Null
        Navigate ($BaseUrl + '/index.html')
        Assert-True ((Evaluate 'document.documentElement.dataset.theme') -eq $scenario.expected) 'System theme or manual preference priority failed'
    }
    # A valid saved preference has priority; unsupported preferences fall back to browser languages.
    foreach ($scenario in @(
        @{ languages = @('en-GB'); saved = ''; expected = 'en' },
        @{ languages = @('nl-BE'); saved = ''; expected = 'nl' },
        @{ languages = @('fr-BE'); saved = ''; expected = 'fr' },
        @{ languages = @('de-DE', 'nl-BE'); saved = ''; expected = 'nl' },
        @{ languages = @('de-DE'); saved = 'invalid'; expected = 'fr' },
        @{ languages = @('en-US'); saved = 'nl'; expected = 'nl' }
    )) {
        $languagesJson = ConvertTo-Json -InputObject $scenario.languages -Compress
        $saved = $scenario.saved
        Evaluate "localStorage.setItem('portfolio-language', '$saved')" | Out-Null
        $injection = Invoke-CDP 'Page.addScriptToEvaluateOnNewDocument' @{ source = "Object.defineProperty(navigator, 'languages', { get: () => $languagesJson });" }
        Navigate ($BaseUrl + '/index.html')
        Assert-True ((Evaluate 'document.documentElement.lang') -eq $scenario.expected) 'Browser-language detection or preference priority failed'
        Invoke-CDP 'Page.removeScriptToEvaluateOnNewDocument' @{ identifier = $injection.identifier } | Out-Null
    }
    $blockedStorage = Invoke-CDP 'Page.addScriptToEvaluateOnNewDocument' @{ source = 'Object.defineProperty(window, "localStorage", { get() { throw new DOMException("Blocked", "SecurityError"); } });' }
    Navigate ($BaseUrl + '/index.html')
    Switch-Language 'nl'
    Switch-Theme 'dark'
    Assert-True ((Evaluate 'document.documentElement.lang') -eq 'nl') 'Switching failed with blocked storage'
    Invoke-CDP 'Page.removeScriptToEvaluateOnNewDocument' @{ identifier = $blockedStorage.identifier } | Out-Null
    $results.Add('PASS browser language, regional variants, saved preference, unsupported-language fallback and blocked storage')
    Invoke-CDP 'Emulation.setDeviceMetricsOverride' @{ width = 360; height = 900; deviceScaleFactor = 1; mobile = $false } | Out-Null
    foreach ($language in @('fr')) {
        Invoke-CDP 'Emulation.setScriptExecutionDisabled' @{ value = $true } | Out-Null
        $path = '/index.html'
        # Runtime evaluation is an inspector operation, even when page scripts are disabled.
        Navigate ($BaseUrl + $path)
        Assert-True (Evaluate 'getComputedStyle(document.querySelector("#navigation")).display !== "none" && document.querySelector(".menu-toggle").hidden') 'No-JavaScript navigation failed'
        Assert-True (Evaluate 'document.documentElement.scrollWidth <= innerWidth') 'No-JavaScript overflow'
        Assert-True (Evaluate 'document.querySelector(".language-switch").hidden && document.documentElement.lang === "fr"') 'No-JavaScript fallback failed'
        Assert-True (Evaluate 'document.querySelector(".project-filters").hidden && document.querySelector(".theme-switch").hidden && document.querySelectorAll("[data-project-topic]:not([hidden])").length === 5 && document.querySelector(".portrait-frame img").naturalWidth === 1372') 'No-JavaScript portrait or projects unavailable'
        $results.Add("PASS $language without JavaScript: visible navigation and readable layout")
        Invoke-CDP 'Emulation.setScriptExecutionDisabled' @{ value = $false } | Out-Null
    }
    foreach ($landscapeTheme in @('light', 'dark')) {
        Invoke-CDP 'Emulation.setDeviceMetricsOverride' @{ width = 844; height = 390; deviceScaleFactor = 1; mobile = $true } | Out-Null
        Navigate ($BaseUrl + '/index.html')
        Switch-Theme $landscapeTheme
        Assert-True (Evaluate 'document.querySelector("#theme").getBoundingClientRect().bottom <= innerHeight && document.querySelector("#navigation").scrollHeight > document.querySelector("#navigation").clientHeight && document.documentElement.scrollWidth <= innerWidth') 'Landscape menu settings cannot be reached by scrolling'
        Close-Menu
        Invoke-CDP 'Emulation.setTouchEmulationEnabled' @{ enabled = $true; maxTouchPoints = 1 } | Out-Null
        $tapPoint = Evaluate '(() => { const rect = document.querySelector(".menu-toggle").getBoundingClientRect(); return { x: rect.x + rect.width / 2, y: rect.y + rect.height / 2 }; })()'
        Invoke-CDP 'Input.dispatchTouchEvent' @{ type = 'touchStart'; touchPoints = @(@{ x = $tapPoint.x; y = $tapPoint.y }) } | Out-Null
        Invoke-CDP 'Input.dispatchTouchEvent' @{ type = 'touchEnd'; touchPoints = @() } | Out-Null
        Evaluate 'new Promise(resolve => setTimeout(resolve, 100))' | Out-Null
        Assert-True (Evaluate 'document.querySelector(".menu-toggle").getAttribute("aria-expanded") === "true"') 'Touch tap did not open the menu'
        Close-Menu
        Invoke-CDP 'Emulation.setTouchEmulationEnabled' @{ enabled = $false } | Out-Null
    }
    $results.Add('PASS short landscape viewport: scrollable menu, reachable settings, touch tap, no horizontal overflow')
    Invoke-CDP 'Emulation.setDeviceMetricsOverride' @{ width = 360; height = 900; deviceScaleFactor = 1; mobile = $false } | Out-Null
    Navigate ($BaseUrl + '/index.html')
    Press-Key 'Tab' 'Tab' 9
    Assert-True (Evaluate 'document.activeElement.matches(".skip-link") && getComputedStyle(document.activeElement).outlineStyle !== "none"') 'Skip link/focus failed'
    Press-Key 'Enter' 'Enter' 13
    Assert-True (Evaluate 'location.hash === "#main"') 'Skip link target failed'
    Invoke-CDP 'Emulation.setEmulatedMedia' @{ features = @(@{ name = 'prefers-reduced-motion'; value = 'reduce' }) } | Out-Null
    Assert-True (Evaluate 'getComputedStyle(document.documentElement).scrollBehavior === "auto"') 'Reduced-motion preference failed'
    Evaluate 'new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve)))' | Out-Null
    Assert-True (Evaluate 'Array.from(document.querySelectorAll(".reveal")).every(node => getComputedStyle(node).transform === "none") && document.getAnimations().length === 0') 'Reduced-motion animations remain active'
    $results.Add('PASS keyboard skip link, visible focus, project filters, portrait, reading progress and reduced motion')
    $fileUrl = ([Uri](Join-Path $repoRoot 'public\index.html')).AbsoluteUri
    Navigate $fileUrl
    foreach ($language in @('fr', 'en', 'nl')) {
        Switch-Language $language
        Assert-True ((Evaluate 'document.documentElement.lang') -eq $language) 'Direct file language switching failed'
    }
    Switch-Language 'fr'
    $missingTranslations = Evaluate @'
(() => {
  const keys = [...Array.from(document.querySelectorAll('[aria-label]'), n => n.getAttribute('aria-label')), ...Array.from(document.querySelectorAll('[alt]'), n => n.alt), document.title, document.querySelector('meta[name="description"]').content];
  const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
  while (walker.nextNode()) {
    const node = walker.currentNode;
    if (!node.parentElement.closest('script, style, #language, noscript, [role=status]') && node.textContent.trim()) keys.push(node.textContent.trim());
  }
  return keys.filter(key => !Object.hasOwn(portfolioTranslations.en, key) || !Object.hasOwn(portfolioTranslations.nl, key));
})()
'@
    Assert-True (@($missingTranslations).Count -eq 0) ('Missing translations: ' + ($missingTranslations -join ', '))
    $results.Add('PASS direct file opening and translation coverage for text, accessible labels, title and description')
    Assert-True ($script:externalRequests.Count -eq 0) ('Unexpected external requests: ' + ($script:externalRequests -join ', '))
    Assert-True ($script:errors.Count -eq 0) ('Browser errors: ' + ($script:errors -join '; '))
    $results.Add('PASS no third-party requests, CSP errors or JavaScript exceptions observed')
    $results | Set-Content -LiteralPath (Join-Path $outputDir 'browser-results.txt') -Encoding UTF8
    $results
} catch {
    if ($script:socket -and $script:socket.State -eq [Net.WebSockets.WebSocketState]::Open) {
        try {
            Evaluate '({url:location.href,ready:document.readyState,width:innerWidth,menu:document.querySelector(".menu-toggle")?.outerHTML,focusTrace:window.focusTrace,active:{tag:document.activeElement?.tagName,id:document.activeElement?.id}})' | ConvertTo-Json -Depth 5 | Write-Output
            $failureImage = Invoke-CDP 'Page.captureScreenshot' @{ format = 'png' }
            [IO.File]::WriteAllBytes((Join-Path $outputDir 'failure.png'), [Convert]::FromBase64String($failureImage.data))
            $script:errors | Write-Output
        } catch { }
    }
    throw
} finally {
    if ($script:socket -and $script:socket.State -eq [Net.WebSockets.WebSocketState]::Open) {
        try { Invoke-CDP 'Browser.close' | Out-Null } catch { }
    }
    if ($script:socket) { $script:socket.Dispose() }
    if ($browserProcess -and -not $browserProcess.HasExited) { Stop-Process -Id $browserProcess.Id -ErrorAction SilentlyContinue }
}
