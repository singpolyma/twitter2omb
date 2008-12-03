<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Twitter to OMB</title>
		<style type="text/css">
			html, body {
				background-color: #eed;
				font-family: Arial, sans-serif;
				text-align: center;
			}
			body {
				margin-top: 5%;
				margin-left: 5%;
				margin-right: 5%;
			}
			label {
				display: block;
				margin-bottom: 1em;
			}
			input {
				margin: auto;
				width: 15em;
				font-size: 1.3em;
				display: block;
				margin-bottom: 0.5em;
			}
			a#forget, a#forget:visited {
				font-size: 1.1em;
				color: blue;
			}
			#notice {
				display: block;
				margin: auto;
				margin-bottom: 1em;
				padding: 0.5em;
				width: 20em;
				border: 1px solid black;
			}
			.success {
				background-color: #cfc;
			}
			.fail {
				background-color: #fcc;
			}
		</style>
	</head>

	<body>
		<h1>Twitter to OpenMicroBlogging Bridge</h1>
		<p>Sorry, all, @<a href="http://identi.ca/evan">evan</a> has blocked this service. You'll have to follow tweeple using <a href="http://twitter.com/">twitter.com</a>.</p>
<?php

require 'normalize_url.php';

session_start();

if(isset($_REQUEST['forget'])) unset($_SESSION['profile_url']);

if($_REQUEST['profile_url'] && !strstr($_REQUEST['profile_url'], '.')) $_REQUEST['profile_url'] = 'http://identi.ca/'.$_REQUEST['profile_url'];

if($_REQUEST['profile_url']) $_SESSION['profile_url'] = normalize_url(str_replace("'",'',$_REQUEST['profile_url']));

if(!$_SESSION['profile_url']) { ?>

<form method="get" action="/"><div>
	<label for="profile_url">Enter your identi.ca <strong>username</strong>
			<br />
		or laconica <strong>profile link</strong>:</label>
	<input type="text" id="profile_url" name="profile_url" />
	<input type="submit" value="Go" />
</div></form>

<?php

} else {

if(isset($_REQUEST['done'])) echo '<p id="notice" class="success">Subscription successfully created!</p>';
if(isset($_REQUEST['fail'])) echo '<p id="notice" class="fail">Failed to create subscription.</p>';

?>

<form method="get" action="/start.php"><div>
	<label for="twitter_name">Enter the <strong>twitter username</strong>
			<br />
		of the person you want to subscribe to:</label>
	<input type="text" id="twitter_name" name="twitter_name" />
	<input type="submit" value="Go" />
</div></form>

<p>
	Note: due to a <a href="http://laconi.ca/trac/ticket/850">limitation in OpenMicroBlogging and Laconi.ca</a>, avatars will not show up.
</p>

<p>
	Note: this will not work for users who have their tweets protected.
</p>

<p>
	The <a href="http://github.com/singpolyma/twitter2omb">source code</a> is available under the <a rel="license" href="/COPYING">license</a>.
</p>

<a id="forget" href="/?forget">Change user</a>

<?php

}

?>
	</body>
</html>
