param(
  [string] $SingBoxPath = "sing-box"
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$policyPath = Join-Path $projectRoot "policy\services.json"
$jsonPath = Join-Path $projectRoot "generated\ru-direct.json"
$srsPath = Join-Path $projectRoot "generated\ru-direct.srs"
$roundTripPath = Join-Path ([IO.Path]::GetTempPath()) "vpn-ru-direct-roundtrip.json"
$utf8NoBom = [Text.UTF8Encoding]::new($false)

try {
  $policy = Get-Content -LiteralPath $policyPath -Raw | ConvertFrom-Json
  $domains = @(
    $policy.services.PSObject.Properties.Value |
      ForEach-Object { $_ } |
      ForEach-Object { $_.Trim().TrimStart(".").ToLowerInvariant() } |
      Where-Object { $_ } |
      Sort-Object -Unique
  )

  if ($domains.Count -eq 0) {
    throw "policy/services.json contains no domains."
  }

  $ruleSet = [ordered]@{
    version = 5
    rules = @(
      [ordered]@{
        domain_suffix = $domains
      }
    )
  }

  $json = $ruleSet | ConvertTo-Json -Depth 20
  [IO.File]::WriteAllText($jsonPath, $json + [Environment]::NewLine, $utf8NoBom)
  $null = Get-Content -LiteralPath $jsonPath -Raw | ConvertFrom-Json

  & $SingBoxPath rule-set compile --output $srsPath $jsonPath
  if ($LASTEXITCODE -ne 0) {
    throw "sing-box rule-set compile failed."
  }

  & $SingBoxPath rule-set decompile --output $roundTripPath $srsPath
  if ($LASTEXITCODE -ne 0) {
    throw "sing-box rule-set decompile failed."
  }

  $compiled = Get-Content -LiteralPath $roundTripPath -Raw | ConvertFrom-Json
  $compiledDomains = @($compiled.rules.domain_suffix | Sort-Object -Unique)
  if (($domains -join "`n") -cne ($compiledDomains -join "`n")) {
    throw "Compiled SRS domain set does not match policy."
  }

  Write-Output "Build successful. Domains: $($domains.Count)"
}
finally {
  Remove-Item -LiteralPath $roundTripPath -Force -ErrorAction SilentlyContinue
}
