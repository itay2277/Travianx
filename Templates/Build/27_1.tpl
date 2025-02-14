<?php

        $artefact = $database->getOwnArtefactInfo($village->wid);
        $result = mysql_num_rows(mysql_query("SELECT * FROM " . TB_PREFIX . "artefacts WHERE vref = " . $village->wid . ""));

?>
<div class="gid27">
<body>
    <table id="own" cellpadding="1" cellspacing="1">
        <thead>
            <tr>
                <th colspan="4">Own artefacts</th>
            </tr>
            <tr>
                <td></td>
                <td>Name</td>
                <td>Village</td>
                <td>Conquered</td>
            </tr>
        </thead>

        <tbody>
            <tr>
            <?php

        if($result == 0) {
        	echo '<td colspan="4" class="none">You do not own any artefacts.</td>';
        } else {
        	if($artefact['size'] == 1) {
        		$reqlvl = 10;
        		$effect = "village";
        	} elseif($artefact['size'] == 2 or 3) {
        		$reqlvl = 20;
        		$effect = "account";
        	}
        	echo '<td class="icon"><img class="artefact_icon_' . $artefact['type'] . '" src="img/x.gif"></td>';
        	echo '<td class="nam">
                            <a href="build.php?id=' . $id . '">' . $artefact['name'] . '</a> <span class="bon">' . $artefact['effect'] . '</span>
                            <div class="info">
                                Treasury <b>' . $reqlvl . '</b>, Effect <b>' . $effect . '</b>
                            </div>
                        </td>';
        	echo '<td class="pla"><a href="karte.php?d=' . $artefact['vref'] . '&c=' . $generator->getMapCheck($artefact['vref']) . '">' . $database->getVillageField($artefact['vref'], "name") . '</a></td>';
        	echo '<td class="dist">' . date("d/m/Y H:i", $artefact['conquered']) . '</td>';
        }

?>
            </tr>
        </tbody>
    </table>

    <table id="near" cellpadding="1" cellspacing="1">
        <thead>
            <tr>
                <th colspan="4">Artefacts in your area</th>
            </tr>

            <tr>
                <td></td>

                <td>Name</td>

                <td>Player</td>

                <td>Distance</td>
            </tr>
        </thead>

        <tbody>
          <?php

        if(mysql_num_rows(mysql_query("SELECT * FROM " . TB_PREFIX . "artefacts")) == 0) {
        	echo '<td colspan="4" class="none">There is no artefacts in your area.</td>';
        } else {


        	function haversine($l1, $o1, $l2, $o2) {
        		$l1 = deg2rad($l1);
        		$sinl1 = sin($l1);
        		$l2 = deg2rad($l2);
        		$o1 = deg2rad($o1);
        		$o2 = deg2rad($o2);

        		return (7926 - 26 * $sinl1) * asin(min(1, 0.707106781186548 * sqrt((1 - (sin($l2) * $sinl1) - cos($l1) * cos($l2) * cos($o2 - $o1)))));
        	}


        	unset($reqlvl);
        	unset($effect);
        	$arts = mysql_query("SELECT * FROM " . TB_PREFIX . "artefacts");
        	$rows = array();
        	while($row = mysql_fetch_array($arts)) {
        		$query = mysql_query('SELECT * FROM `' . TB_PREFIX . 'wdata` WHERE `id` = ' . $row['vref']);
        		$coor2 = mysql_fetch_assoc($query);

        		$wref = $village->wid;
        		$coor = $database->getCoor($wref);
        		$dist = haversine($coor['x'], $coor['y'], $coor2['x'], $coor2['y']);

        		$rows[$dist] = $row;

        	}
        	ksort($rows, SORT_DESC);
        	foreach($rows as $row) {
        		echo '<tr>';
        		echo '<td class="icon"><img class="artefact_icon_' . $row['type'] . '" src="img/x.gif" alt="" title=""></td>';
        		echo '<td class="nam">';
        		echo '<a href="build.php?id=' . $id . '">' . $row['name'] . '</a> <span class="bon">' . $row['effect'] . '</span>';
        		echo '<div class="info">';
        		if($row['size'] == 1) {
        			$reqlvl = 10;
        			$effect = "village";
        		} elseif($row['size'] == 2 or $row['size'] == 3) {
        			$reqlvl = 20;
        			$effect = "account";
        		}
        		echo '<div class="info">Treasury <b>' . $reqlvl . '</b>, Effect <b>' . $effect . '</b>';
        		echo '</div></td><td class="pla"><a href="karte.php?d=' . $row['vref'] . '&c=' . $generator->getMapCheck($row['vref']) . '">' . $database->getUserField($row['owner'], "username", 0) . '</a></td>';
        		echo '<td class="dist">' . haversine($coor['x'], $coor['y'], $coor2['x'], $coor2['y']) . '</td>';
        		echo '</tr>';
        	}
        }

?>
        </tbody>
    </table>
</div>
