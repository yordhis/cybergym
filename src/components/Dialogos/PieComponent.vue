<template>
  <v-footer  padless class="mt-5" >
    <v-card class="flex" flat tile>

      <v-card-text class="py-2 text-center">
        {{ new Date().getFullYear() }} — Desarrollado por <a href="https://cyberstaffstore.com/" target="_blank">Cyber Staff C.A | Click para soporte</a> 
      </v-card-text>
    </v-card>
  </v-footer>
</template>
<script>
export default {
  name: "PieComponent",
};
</script>