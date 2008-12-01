<?php

session_start();

$_SESSION['profile_url'] = str_replace("'",'',$_SESSION['profile_url']);
$_SESSION['twitter_name'] = str_replace("'",'',$_REQUEST['twitter_name']);

exec("./omb.rb '{$_SESSION['profile_url']}' '{$_SESSION['twitter_name']}'", $r);

var_dump($r);

$_SESSION['request_token'] = $r[0];
$_SESSION['request_token_secret'] = $r[1];
header('Location: '.$r[2],true,303);

if(!$r[2]) echo 'error... this user may have protected updates.'

?>
