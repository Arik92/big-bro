<template>
  <mainPage />
</template>

<script>
import MainPage from './components/mainPage.vue'

export default {
  name: 'App',
  components: {
    MainPage
  }  
}
</script>

<style>
body {
  position: absolute;
  height: 100%;
  width: 100%;
  margin: 0;
  background-color: goldenrod;
}
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #050709;
  margin-top: 60px;
  position: absolute;
  height: 90%;
  width: 90%;
  left: 5%;
  background-image: url('~@/assets/beach.jpg');
  background-position: center; /* Center the image */
  background-repeat: no-repeat; /* Do not repeat the image */
  background-size: cover; /* Resize the background image to cover the entire container */
}
</style>
