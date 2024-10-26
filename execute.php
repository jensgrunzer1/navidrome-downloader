<?php
header("Content-Type: text/event-stream");
header("Cache-Control: no-cache");
header("Connection: keep-alive");

// Pufferung ausschalten, damit die Daten sofort an den Client gesendet werden
while (ob_get_level() > 0) { ob_end_flush(); }
ob_implicit_flush(true);

$parameter = escapeshellarg($_GET['parameter']); // Eingabe absichern
$command = "./script.sh $parameter"; // Bash-Skript mit Parameter ausführen

$process = popen($command, "r");
if (!$process) {
    echo "event: error\n";
    echo "data: Konnte das Skript nicht starten\n\n";
    flush();
    exit;
}

while (!feof($process)) {
    $output = fgets($process); // Zeile für Zeile lesen
    if ($output !== false) {
        echo "data: " . trim($output) . "\n\n"; // Zeile an Client senden
        flush(); // Daten sofort an den Client senden
    }
}

pclose($process);
echo "event: complete\n";
echo "data: Fertig!\n\n";
flush();
?>
