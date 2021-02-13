---
layout: default
title: "bdk"
image: 
  path: img/bitcoindevkit.svg
  height: 100
  width: 100
nav_order: 2
description: "Exploring the bitcoindevkit through a series of examples"
permalink: /bdk
---

<div style="display: flex; justify-content: space-evenly; margin-top: 1rem;">
  <img src="./img/rust.svg" width="200">
  
  <div style="display: flex; align-items: center; justify-content: center;">
    <div>
      <h1>
        bdk
      </h1>
      <p style="margin: 0 0 0.5em 0">
        <em>v0.3.0</em>
      </p>
      <a href="https://github.com/bitcoindevkit/bdk">
        <h4>
          <em>Source</em>
        </h4>
      </a>
    </div>
  </div>
</div>
<hr/>

This section is under construction! Feel free to open a PR [here](https://github.com/thunderbiscuit/bitcoindevkit-by-example).

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
