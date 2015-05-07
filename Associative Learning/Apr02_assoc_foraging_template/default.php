<html>
<head>
<title>MCB 419: Sketches</title>
    <link rel="stylesheet" type="text/css" href="/mcb/419/style419.css">
    <script src="/mcb/419/sketches/processing.min.js"></script>
    <script type="text/javascript" src="/mcb/419/sketches/shCore.js"></script>
	<script type="text/javascript" src="/mcb/419/sketches/shBrushProcessing.js"></script>
	<link type="text/css" rel="stylesheet" href="/mcb/419/sketches/shCoreDefault.css"/>
	<script type="text/javascript">SyntaxHighlighter.all();</script>
</head>
<? include("/mcb/419/header419.php"); ?>
<? include("../localnav.php"); ?>
<h1>Sketches</h1>	

<h3>Seek Forage</h3>
<p>Use Reynold's SEEK strategy to guide foraging (Feb 19 quiz).
</p>


<canvas data-processing-sources="Feb19_quiz_seek_solution.pde Bot.pde Pellet.pde"></canvas>

<h3>Source code:</h3>
<script type="syntaxhighlighter" class="brush: processing"><![CDATA[
<? include("Feb19_quiz_seek_solution.pde"); ?>
]]></script>

<h3>Bot class:</h3>
<script type="syntaxhighlighter" class="brush: processing"><![CDATA[
<? include("Bot.pde"); ?>
]]></script>

<h3>Pellet class:</h3>
<script type="syntaxhighlighter" class="brush: processing"><![CDATA[
<? include("Pellet.pde"); ?>
]]></script>

<? include("/mcb/419/footer419.php"); ?>
