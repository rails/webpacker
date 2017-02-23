<template>
  <button :class="'btn btn-' + type + ' btn-' + size">
    <slot></slot>
  </button>
</template>

<script>
  export default {
    props: {
      type: {
        type: String,
        default: 'default'
      },
      size: {
        type: String,
        default: 'md'
      }
    }
  }
</script>
