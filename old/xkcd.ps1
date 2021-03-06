$xml = [xml](gc .\*.dzprj)

$images = $xml.DeepZoomComposerProject.ImageList.Image | select Id,File
$im = @{}
$images | %{$im[$_.Id] = $_.File}

$xml.DeepZoomComposerProject.CompositionList.Composition.CompositionNode | %{
    $file = $im[$_.ImageId]
    if ($file -eq 'background.png') {
        $_.X = '0'
        $_.Y = '0'
        $_.Width = '165888'
        $_.Height = '65536'
    } elseif($file -match '^(\d+)([ns])(\d+)([we])\.png$') {
        [int]$y,$ns,[int]$x,$we = $Matches[1..4]
        if ($ns -eq 'n') { $y = -$y+1 }
        if ($we -eq 'w') { $x = -$x+1 }
        $y += 12
        $x += 32
        
        $_.X = ($x * 2048).ToString()
        $_.Y = ($y * 2048).ToString()
        $_.Width = '2048'
        $_.Height = '2048'
    }
}

$xml.Save((gci .\*.dzprj).FullName)