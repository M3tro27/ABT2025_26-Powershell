$text = "Kobyla má malý bok"
$array = $text.ToCharArray()
$sorted_array = $array | Sort-Object
$final_string = $sorted_array -Join ''
$final_string