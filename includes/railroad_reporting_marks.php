<?php

/*
TrainTote railroad reporting mark inference helpers.

These helpers infer standard reporting marks only from clear, recognized road
names. They must not be used to override reporting marks that were directly
read from a model.
*/

if (!function_exists('tt_railroad_normalize_road_name')) {
    function tt_railroad_normalize_road_name($roadName)
    {
        $roadName =
            strtolower(
                trim(
                    (string)$roadName
                )
            );

        $roadName =
            str_replace(
                '&',
                ' and ',
                $roadName
            );

        $roadName =
            preg_replace(
                '/[^a-z0-9]+/',
                ' ',
                $roadName
            );

        return trim(
            preg_replace(
                '/\s+/',
                ' ',
                $roadName
            )
        );
    }
}

if (!function_exists('tt_railroad_road_name_is_uncertain')) {
    function tt_railroad_road_name_is_uncertain($roadName)
    {
        $roadName =
            (string)$roadName;

        if (strpos($roadName, '?') !== false) {
            return true;
        }

        return (bool)preg_match(
            '/\b(possible|possibly|probable|probably|likely|maybe|uncertain|unclear|unknown|appears|appears to be|looks like|look like|might be|could be|seems|seems to be|unidentified)\b/i',
            $roadName
        );
    }
}

if (!function_exists('tt_railroad_reporting_mark_aliases')) {
    function tt_railroad_reporting_mark_aliases()
    {
        return [
            'southern pacific' => 'SP',
            'sp' => 'SP',
            'union pacific' => 'UP',
            'up' => 'UP',
            'bnsf' => 'BNSF',
            'burlington northern santa fe' => 'BNSF',
            'burlington northern santa fe railway' => 'BNSF',
            'burlington northern' => 'BN',
            'bn' => 'BN',
            'santa fe' => 'ATSF',
            'atchison topeka and santa fe' => 'ATSF',
            'atsf' => 'ATSF',
            'csx' => 'CSXT',
            'csx transportation' => 'CSXT',
            'csxt' => 'CSXT',
            'norfolk southern' => 'NS',
            'ns' => 'NS',
            'conrail' => 'CR',
            'consolidated rail corporation' => 'CR',
            'cr' => 'CR',
            'canadian national' => 'CN',
            'cn' => 'CN',
            'canadian pacific' => 'CP',
            'cp rail' => 'CP',
            'cp' => 'CP',
            'kansas city southern' => 'KCS',
            'kcs' => 'KCS',
            'new york central' => 'NYC',
            'nyc' => 'NYC',
            'pennsylvania railroad' => 'PRR',
            'pennsylvania' => 'PRR',
            'prr' => 'PRR',
            'baltimore and ohio' => 'B&O',
            'b and o' => 'B&O',
            'chesapeake and ohio' => 'C&O',
            'c and o' => 'C&O',
            'rio grande' => 'D&RGW',
            'denver and rio grande western' => 'D&RGW',
            'denver rio grande western' => 'D&RGW',
            'd and rgw' => 'D&RGW',
            'drgw' => 'D&RGW',
            'cotton belt' => 'SSW',
            'st louis southwestern' => 'SSW',
            'saint louis southwestern' => 'SSW',
            'ssw' => 'SSW',
            'frisco' => 'SLSF',
            'st louis san francisco' => 'SLSF',
            'saint louis san francisco' => 'SLSF',
            'slsf' => 'SLSF',
            'sl sf' => 'SLSF',
            'milwaukee road' => 'MILW',
            'chicago milwaukee st paul and pacific' => 'MILW',
            'chicago milwaukee saint paul and pacific' => 'MILW',
            'milw' => 'MILW',
            'rock island' => 'RI',
            'chicago rock island and pacific' => 'RI',
            'ri' => 'RI',
            'new haven' => 'NH',
            'new york new haven and hartford' => 'NH',
            'nynh and h' => 'NH',
            'nh' => 'NH',
            'great northern' => 'GN',
            'gn' => 'GN',
            'northern pacific' => 'NP',
            'np' => 'NP',
            'illinois central' => 'IC',
            'ic' => 'IC',
            'illinois central gulf' => 'ICG',
            'icg' => 'ICG',
            'missouri pacific' => 'MP',
            'mp' => 'MP',
            'western pacific' => 'WP',
            'wp' => 'WP',
            'penn central' => 'PC',
            'pc' => 'PC',
            'seaboard air line railroad' => 'SAL',
            'seaboard air line' => 'SAL',
            'sal' => 'SAL',
            'seaboard coast line' => 'SCL',
            'scl' => 'SCL',
            'atlantic coast line' => 'ACL',
            'acl' => 'ACL',
            'louisville and nashville' => 'L&N',
            'l and n' => 'L&N',
            'erie lackawanna' => 'EL',
            'el' => 'EL',
            'erie railroad' => 'ERIE',
            'erie' => 'ERIE',
            'lackawanna' => 'DL&W',
            'delaware lackawanna and western' => 'DL&W',
            'dl and w' => 'DL&W',
            'lehigh valley' => 'LV',
            'lv' => 'LV',
            'reading' => 'RDG',
            'reading railroad' => 'RDG',
            'rdg' => 'RDG',
            'nickel plate road' => 'NKP',
            'new york chicago and st louis' => 'NKP',
            'new york chicago and saint louis' => 'NKP',
            'nkp' => 'NKP',
            'wabash' => 'WAB',
            'wab' => 'WAB',
            'norfolk and western' => 'NW',
            'n and w' => 'NW',
            'nw' => 'NW',
            'virginian' => 'VGN',
            'virginian railway' => 'VGN',
            'vgn' => 'VGN',
            'southern railway' => 'SOU',
            'southern' => 'SOU',
            'sou' => 'SOU',
            'gulf mobile and ohio' => 'GM&O',
            'gm and o' => 'GM&O',
            'gmo' => 'GM&O',
            'monon' => 'MON',
            'chicago indianapolis and louisville' => 'MON',
            'mon' => 'MON',
            'new york ontario and western' => 'NYO&W',
            'nyo and w' => 'NYO&W',
            'boston and maine' => 'BM',
            'b and m' => 'BM',
            'maine central' => 'MEC',
            'mec' => 'MEC',
            'central vermont' => 'CV',
            'cv' => 'CV',
            'grand trunk western' => 'GTW',
            'gtw' => 'GTW',
            'soo line' => 'SOO',
            'soo' => 'SOO',
            'chicago and north western' => 'CNW',
            'c and nw' => 'CNW',
            'cnw' => 'CNW',
            'chicago burlington and quincy' => 'CB&Q',
            'cb and q' => 'CB&Q',
            'burlington route' => 'CB&Q',
            'missouri kansas texas' => 'MKT',
            'katy' => 'MKT',
            'mkt' => 'MKT',
            'texas and pacific' => 'T&P',
            't and p' => 'T&P',
            'new york susquehanna and western' => 'NYS&W',
            'nys and w' => 'NYS&W',
            'susquehanna' => 'NYS&W',
            'delaware and hudson' => 'D&H',
            'd and h' => 'D&H',
            'pittsburgh and lake erie' => 'P&LE',
            'p and le' => 'P&LE',
            'chicago great western' => 'CGW',
            'cgw' => 'CGW',
            'elgin joliet and eastern' => 'EJ&E',
            'ej and e' => 'EJ&E',
            'florida east coast' => 'FEC',
            'fec' => 'FEC',
            'alaska railroad' => 'ARR',
            'arr' => 'ARR',
            'amtrak' => 'AMTK',
            'amtk' => 'AMTK',
            'railbox' => 'RBOX',
            'rbox' => 'RBOX',
            'ttx' => 'TTX',
            'trailer train' => 'TTX',
            'trailertrain' => 'TTX',
            'golden west service' => 'GVSR',
            'golden west' => 'GVSR',
            'gvsr' => 'GVSR',
            'british columbia railway' => 'BCIT',
            'bc rail' => 'BCOL',
            'bcol' => 'BCOL',
            'bcit' => 'BCIT',
            'illinois terminal' => 'ITC',
            'itc' => 'ITC',
            'gatx' => 'GATX',
            'tbox' => 'TBOX',
            'railcar pooling experts' => 'TBOX',
        ];
    }
}

if (!function_exists('tt_railroad_reporting_marks_for_road_name')) {
    function tt_railroad_reporting_marks_for_road_name($roadName)
    {
        if (
            trim(
                (string)$roadName
            ) === ''
            || tt_railroad_road_name_is_uncertain($roadName)
        ) {
            return '';
        }

        $aliases =
            tt_railroad_reporting_mark_aliases();

        $normalizedRoadName =
            tt_railroad_normalize_road_name(
                $roadName
            );

        return
            $aliases[$normalizedRoadName]
            ?? '';
    }
}
