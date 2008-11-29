<?php

session_start();

$_SESSION['twitter_name'] = str_replace("'",'',$_REQUEST['twitter_name']);

exec("./omb.rb '{$_SESSION['profile_url']}' '{$_SESSION['twitter_name']}'", $r);

$_SESSION['request_token'] = $r[0];
$_SESSION['request_token_secret'] = $r[1];
header('Location: '.$r[2],true,303);

?>
