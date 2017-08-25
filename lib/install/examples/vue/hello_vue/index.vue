<template>
  <div id="app">
    <div class="content">
      <p>{{ message }}</p>
      <img src='./vue.png' class="vue-logo" alt="React" />
    </div>
  </div>
</template>

<script>
  export default {
    data: function () {
      return {
        message: "Hello Vue!"
      }
    }
  }
</script>

<style scoped>
  .content {
    text-align: center;
  }

  p {
    font-size: 2em;
    text-align: center;
  }

  .vue-logo {
    display: block;
    margin: 0 auto;
    max-width: 100px;
  }
</style>
