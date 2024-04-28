<html>
<head>
<meta name="viewpot" content="width=device-width" />
<title>Automatic Gate Control</title>
</head>
<body>
Open entrance gate:
<form method="get" action="index.php">
<input type="submit" value="Open Entrance Gate" name="entrance_open">
<input type="submit" value="Close Entrance Gate" name="entrance_close">
<br>
<input type="submit" value="Open Decision Gates" name="decision_open">
<input type="submit" value="Close Decision Gates" name="decision_close">
<br>
<br>
<input type="submit" value="Shutdown Pi" name="shutdown">
</form>

<?php
if(isset($_GET['entrance_open'])){
exec('sudo python3 /home/pi/motor1_open.py');
echo "Entrance gate opening";
}
else if(isset($_GET['entrance_close'])){
exec("sudo echo '0' > /home/pi/state_motor1.txt");
sleep(1);
exec('sudo python3 /home/pi/motor1_close.py');
echo "Entrance gate closing";
}
else if(isset($_GET['decision_open'])){
exec('sudo python3 /home/pi/motor3_open.py & sudo python3 /home/pi/motor2_open.py &');
echo "Decision gate opening";
}
else if(isset($_GET['decision_close'])){
exec("sudo echo '0' > /home/pi/state_motor2.txt");
exec("sudo echo '0' > /home/pi/state_motor3.txt");
sleep(1);
exec('sudo python3 /home/pi/motor3_close.py & sudo python3 /home/pi/motor2_close.py &');
echo "Decision gate closing";
}
else if(isset($_GET['shutdown'])){
exec('sudo poweroff');
echo "Shutting down...";
}
