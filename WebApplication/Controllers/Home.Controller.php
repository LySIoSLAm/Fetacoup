<?php

     if (!isset($_SESSION)) {
         session_start();
     }

     if ($_SERVER['SCRIPT_FILENAME'] == __FILE__) {
         $racine = "..";
     }

     $tile = "Accueil";

     include "$racine/Views/HeaderPage.Html.php";
     include "$racine/Views/HomePage.Html.php";
     include "$racine/Views/FooterPage.Html.php";

?>