<?php

session_start();

$_SESSION['profile_url'] = str_replace("'",'',$_SESSION['profile_url']);
$_SESSION['twitter_name'] = str_replace("'",'',$_SESSION['twitter_name']);
$_SESSION['request_token'] = str_replace("'",'',$_SESSION['request_token']);
$_SESSION['request_token_secret'] = str_replace("'",'',$_SESSION['request_token_secret']);

exec("./omb.rb '{$_SESSION['profile_url']}' '{$_SESSION['twitter_name']}' '{$_SESSION['request_token']}' '{$_SESSION['request_token_secret']}'", $r);


if($r[0] && $r[0] != 'nil') {
	file_put_contents('tokens/'.sha1($r[3]), implode("\n",$r));
	header('Location: http://tw2omb.singpolyma.net/?done',true,303);
} else {
	header('Location: http://tw2omb.singpolyma.net/?fail',true,303);
}

?>
