<?php

    function MainController($action)
    {
        $actions = array();

        $actions['default'] = 'Home.Controller.php';
        $actions['home'] = 'Home.Controller.php';

        if (array_key_exists($action, $actions)) {
            return $actions[$action];
        } else {
            return $actions['default'];
        }
    }

?>