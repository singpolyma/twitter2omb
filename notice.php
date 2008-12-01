<?php

$_REQUEST['id'] = str_replace("'",'',$_REQUEST['id']);
exec("./twitter_status.rb '{$_REQUEST['id']}'", $r);
header('Location: '.$r[0],true,303);

?>
