<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('Home');
});

Route::get('/about',function(){
    return view('About');
});

Route::get('/contact',function(){
    return view('Contact');
});
