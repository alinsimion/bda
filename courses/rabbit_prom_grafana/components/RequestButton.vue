<template>
  <button
    :disabled="loading"
    @click="makeRequest"
    class="px-4 py-2 rounded-lg bg-blue-600 text-white hover:bg-blue-700 disabled:opacity-50"
  >
    <span v-if="!loading">{{ label }}</span>
    <span v-else>Loading...</span>
  </button>
</template>

<script setup>
import { ref } from 'vue'

const props = defineProps({
  url: { type: String, required: true },
  method: { type: String, default: 'GET' },
  label: { type: String, default: 'Send Request' },
})

const emit = defineEmits(['success', 'error'])

const loading = ref(false)

async function makeRequest() {
  loading.value = true
  try {
    const response = await fetch(props.url, { method: props.method })
    const data = await response.json().catch(() => null)
    emit('success', { response, data })
  } catch (err) {
    emit('error', err)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
button {
  transition: background-color 0.2s ease;
}
</style>
