<?php

session_start();

if(isset($_REQUEST['forget'])) unset($_SESSION['profile_url']);

if($_REQUEST['profile_url'] && !strstr($_REQUEST['profile_url'], '.')) $_REQUEST['profile_url'] = 'http://identi.ca/'.$_REQUEST['profile_url'];

if($_REQUEST['profile_url']) $_SESSION['profile_url'] = str_replace("'",'',$_REQUEST['profile_url']);

if(!$_SESSION['profile_url']) { ?>

<form method="get" action="/"><div>
	Enter your identi.ca/laconica profile URL:
	<input type="text" name="profile_url" />
	<input type="submit" value="Go" />
</div></form>

<?php
	exit;
}

?>

<form method="get" action="/start.php"><div>
	Enter the twitter username of the person you want to subscribe to:
	<input type="text" name="twitter_name" />
	<input type="submit" value="Go" />
</div></form>

<a href="/?forget">Forget / change user</a>
