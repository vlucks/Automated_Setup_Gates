<html>
<head>
<meta name="viewpot" content="width=device-width" />
<title>Remote Gate Control</title>
</head>
<body>
Control setup gate:
<form method="get" action="index.php">
<input type="submit" value="Open Gate" name="entrance_open">
<input type="submit" value="Close Gate" name="entrance_close">
<br>
<input type="submit" value="Shutdown Pi" name="shutdown">
</form>

<?php
if(isset($_GET['entrance_open'])){
exec('sudo python3 /home/pi/motor_open.py');
echo "Gate opening";
}
else if(isset($_GET['entrance_close'])){
exec('sudo python3 /home/pi/motor_close.py');
echo "Gate closing";
}
else if(isset($_GET['shutdown'])){
exec('sudo poweroff');
echo "Shutting down...";
}
