<?php

    include 'GetRoot.php';
    include "$racine/Controllers/Main.Controller.php";
    if (isset($_GET['action'])) {
        $action = $_GET['action'];
    } else {
        $action = 'default';
    }
    $file =  MainController($action);
    include "$racine/Controllers/$file";

?>
