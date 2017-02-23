<template>
  <div id="app" class="container">
    <div class="row">
      <div class="col-sm-6">
        <h1>Todos</h1>
        <todo-list></todo-list>
      </div>
      <div class="col-sm-6">
        <img src="./assets/logo.png" alt="Vue logo">
      </div>
    </div>
  </div>
</template>

<script>
  import TodoList from './components/todo-list.vue'

  export default {
    components: {
      TodoList
    }
  }
</script>
