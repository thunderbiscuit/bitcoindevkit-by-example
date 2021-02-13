---
layout: default
title: "Bitcoindevkit by Example"
image: 
  path: img/bitcoindevkit.png
  height: 100
  width: 100
nav_order: 1
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /
---

<div style="display: flex; justify-content: space-evenly; margin-top: 2rem;">
  <img src="./img/bitcoindevkit.svg" width="200">
  
  <div style="display: flex; align-items: center; justify-content: center;">
    <div>
      <h1>
        Bitcoindevkit by Example
      </h1>
      <p>
        Exploring the bitcoindevkit ecosystem through a series of examples
      </p>
      <button class="btn js-toggle-dark-mode">
        Come to the dark side
      </button>
    </div>
  </div>
</div>
<br/>
<br/>
<br/>
<div style="display: flex; justify-content: space-evenly;">
  <a href="/bitcoindevkit-by-example/bdk-cli" 
     style="display: flex; flex-direction: column; align-items: center;">
    <img src="./img/bash.svg" width="40">
    <h4 style="margin-top: 1.5em; font-size: 14px !important">bdk-cli</h4>
  </a>
  <a href="/bitcoindevkit-by-example/bdk"
     style="display: flex; flex-direction: column; align-items: center;">
    <img src="./img/rust.svg" width="40">
    <h4 style="margin-top: 1.5em; font-size: 14px !important">bdk</h4>
  </a>
  <a href="/bitcoindevkit-by-example/bdk-jni"
     style="display: flex; flex-direction: column; align-items: center;">
    <img src="./img/android.svg" width="40">
    <h4 style="margin-top: 1.5em; font-size: 14px !important">bdk-jni</h4>
  </a>
</div>
<br/>


<script>
const toggleDarkMode = document.querySelector('.js-toggle-dark-mode');

jtd.addEvent(toggleDarkMode, 'click', function(){
  if (jtd.getTheme() === 'dark') {
    jtd.setTheme('light');
    toggleDarkMode.textContent = 'Come to the dark side';
  } else {
    jtd.setTheme('dark');
    toggleDarkMode.textContent = 'Return to the light side';
  }
});
</script>
