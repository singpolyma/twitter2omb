<?php

session_start();

$_SESSION['profile_url'] = str_replace("'",'',$_REQUEST['profile_url']);
$_SESSION['twitter_name'] = str_replace("'",'',$_REQUEST['twitter_name']);
$_SESSION['request_token'] = str_replace("'",'',$_REQUEST['request_token']);
$_SESSION['request_token_secret'] = str_replace("'",'',$_REQUEST['request_token_secret']);

exec("./omb.rb '{$_SESSION['profile_url']}' '{$_SESSION['twitter_name']}' '{$_SESSION['request_token']}' '{$_SESSION['request_token_secret']}'", $r);

file_put_contents('tokens/'.sha1($r[3]), implode("\n",$r));

header('Location: http://tw2omb.singpolyma.net/',true,303);

?>
